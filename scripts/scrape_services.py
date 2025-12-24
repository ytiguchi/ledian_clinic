#!/usr/bin/env python3
"""
レディアンクリニック サービスページスクレイパー
WEBから商品説明コンテンツを構造化して取得

Usage:
    python scripts/scrape_services.py

Output:
    - data/scraped/services.json (構造化されたコンテンツ)
    - database/d1/seed_service_content.sql (SQLシード)
"""

import sys
import io

# Windows cp932 encoding fix
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

import json
import re
import time
import uuid
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional
from urllib.parse import urljoin

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    print("[ERROR] 必要なパッケージをインストールしてください:")
    print("  pip install requests beautifulsoup4")
    exit(1)


# ============================================
# データクラス定義
# ============================================

@dataclass
class Feature:
    """特徴・こだわり"""
    title: str
    description: str
    sort_order: int = 0


@dataclass
class Recommendation:
    """おすすめの方"""
    text: str
    sort_order: int = 0


@dataclass
class Overview:
    """施術概要"""
    duration: Optional[str] = None
    downtime: Optional[str] = None
    frequency: Optional[str] = None
    makeup: Optional[str] = None
    bathing: Optional[str] = None
    contraindications: Optional[str] = None


@dataclass
class FAQ:
    """よくある質問"""
    question: str
    answer: Optional[str] = None
    sort_order: int = 0


@dataclass
class BeforeAfter:
    """症例写真"""
    before_image_url: str
    after_image_url: str
    before_description: Optional[str] = None
    after_description: Optional[str] = None
    treatment_info: Optional[str] = None


@dataclass
class ServiceContent:
    """サービスコンテンツ"""
    name_ja: str
    name_en: Optional[str] = None
    slug: str = ""
    source_url: str = ""
    about_subtitle: Optional[str] = None
    about_description: Optional[str] = None
    hero_image_url: Optional[str] = None
    features: list[Feature] = field(default_factory=list)
    recommendations: list[Recommendation] = field(default_factory=list)
    overview: Optional[Overview] = None
    faqs: list[FAQ] = field(default_factory=list)
    before_afters: list[BeforeAfter] = field(default_factory=list)
    category_name: Optional[str] = None


# ============================================
# スクレイパー
# ============================================

BASE_URL = "https://ledianclinic.jp"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}


def get_soup(url: str) -> BeautifulSoup:
    """URLからBeautifulSoupオブジェクトを取得"""
    print(f"  [FETCH] {url}")
    response = requests.get(url, headers=HEADERS, timeout=30)
    response.raise_for_status()
    return BeautifulSoup(response.text, "html.parser")


def extract_slug(url: str) -> str:
    """URLからスラッグを抽出"""
    # /service/potenza/ -> potenza
    match = re.search(r"/service/([^/]+)/?$", url)
    return match.group(1) if match else ""


def scrape_service_list() -> list[dict]:
    """サービス一覧ページからサービスURLを取得"""
    print("[INFO] サービス一覧を取得中...")
    soup = get_soup(f"{BASE_URL}/service")
    
    services = []
    current_category = ""
    
    # 全てのh4とリンクを探索
    main_content = soup.find("main")
    if not main_content:
        print("[WARN] main要素が見つかりません、bodyを検索")
        main_content = soup.find("body")
    
    # h4カテゴリとその下のリンクを取得
    for h4 in main_content.find_all("h4"):
        current_category = h4.get_text(strip=True)
        
        # h4の親要素からサービスリンクを探す
        parent = h4.find_parent()
        if parent:
            for link in parent.find_all("a", href=True):
                url = link.get("href", "")
                if "/service/" in url and url != "/service/" and url != "/service":
                    name = link.get_text(strip=True)
                    if name:
                        full_url = urljoin(BASE_URL, url)
                        services.append({
                            "name": name,
                            "url": full_url,
                            "category": current_category,
                            "slug": extract_slug(url)
                        })
    
    # 上記で見つからない場合、全リンクを探索
    if not services:
        print("[INFO] 別の方法でリンクを探索中...")
        for link in main_content.find_all("a", href=True):
            url = link.get("href", "")
            if "/service/" in url and url not in ["/service/", "/service"]:
                name = link.get_text(strip=True)
                if name and len(name) < 50:  # 長すぎるテキストは除外
                    full_url = urljoin(BASE_URL, url)
                    services.append({
                        "name": name,
                        "url": full_url,
                        "category": "",
                        "slug": extract_slug(url)
                    })
    
    # 重複を除去
    seen = set()
    unique_services = []
    for s in services:
        if s["url"] not in seen:
            seen.add(s["url"])
            unique_services.append(s)
    
    print(f"[INFO] {len(unique_services)} 件のサービスを発見")
    return unique_services


def scrape_service_page(url: str, category_name: str) -> Optional[ServiceContent]:
    """個別サービスページをスクレイピング"""
    try:
        soup = get_soup(url)
    except Exception as e:
        print(f"  [ERROR] ページ取得失敗: {e}")
        return None
    
    content = ServiceContent(
        name_ja="",
        source_url=url,
        slug=extract_slug(url),
        category_name=category_name
    )
    
    # 1. 基本情報 (タイトル)
    # メインコンテンツ内のh1を優先
    main = soup.find("main")
    h1 = main.find("h1") if main else soup.find("h1")
    if h1:
        content.name_ja = h1.get_text(strip=True)
        # 重複削除 (例: "ポテンツァ ポテンツァ" -> "ポテンツァ")
        words = content.name_ja.split()
        if len(words) >= 2 and words[0] == words[1]:
            content.name_ja = words[0]
    
    # 英語名 (h1の次にあるh2)
    if h1:
        next_h2 = h1.find_next("h2")
        if next_h2:
            en_text = next_h2.get_text(strip=True)
            if en_text.isupper() or re.match(r"^[A-Za-z\s\d]+$", en_text):
                content.name_en = en_text
    
    # 2. ABOUT セクション
    about_h3 = soup.find("h3", string=re.compile("ABOUT"))
    if about_h3:
        parent = about_h3.find_parent()
        if parent:
            h4 = parent.find("h4")
            if h4:
                content.about_subtitle = h4.get_text(strip=True)
            
            # 説明テキストを探す (親からテキストノードを収集)
            texts = []
            for elem in parent.find_all(string=True, recursive=True):
                text = elem.strip()
                if text and text != "ABOUT" and text != content.about_subtitle:
                    if len(text) > 30:
                        texts.append(text)
            if texts:
                content.about_description = texts[0]
    
    # 3. ヒーロー画像 (最初の大きな画像)
    for img in soup.find_all("img"):
        src = img.get("src", "")
        alt = img.get("alt", "")
        if src and ("service" in src or alt == content.name_ja or "hero" in src.lower()):
            content.hero_image_url = urljoin(url, src)
            break
    
    # 4. 特徴・こだわり (FEATURES)
    features_h2 = soup.find("h2", string=re.compile("特徴"))
    if features_h2:
        # 親divを探して、その中のh4とpを取得
        parent = features_h2.find_parent()
        while parent and parent.name != "section" and len(parent.find_all("h4")) == 0:
            parent = parent.find_parent()
        
        if parent:
            # h4とそれに続くpをペアで取得
            feature_divs = parent.find_all("h4")
            for i, h4 in enumerate(feature_divs):
                title = h4.get_text(strip=True)
                # 直後のp要素を探す
                desc = ""
                next_elem = h4.find_next_sibling()
                if not next_elem:
                    next_elem = h4.find_parent().find_next_sibling()
                if next_elem:
                    p = next_elem.find("p") if next_elem.name != "p" else next_elem
                    if p:
                        desc = p.get_text(strip=True)
                
                if title and title != "FEATURES":
                    content.features.append(Feature(
                        title=title,
                        description=desc,
                        sort_order=i
                    ))
    
    # 5. おすすめの方 (RECOMMEND)
    recommend_h3 = soup.find("h3", string=re.compile("おすすめ"))
    if recommend_h3:
        parent = recommend_h3.find_parent()
        while parent and len(parent.find_all("p")) < 2:
            parent = parent.find_parent()
        
        if parent:
            for i, p in enumerate(parent.find_all("p")):
                text = p.get_text(strip=True)
                if text and text != "RECOMMEND" and len(text) < 100 and len(text) > 3:
                    content.recommendations.append(Recommendation(
                        text=text,
                        sort_order=i
                    ))
    
    # 6. 施術概要 (OVERVIEW)
    overview_h3 = soup.find("h3", string=re.compile("施術概要"))
    if overview_h3:
        table = overview_h3.find_next("table")
        if table:
            overview = Overview()
            for row in table.find_all("tr"):
                cells = row.find_all(["th", "td"])
                if len(cells) >= 2:
                    key = cells[0].get_text(strip=True)
                    value = cells[1].get_text(strip=True)
                    
                    if "施術時間" in key or "時間" in key:
                        overview.duration = value
                    elif "ダウンタイム" in key:
                        overview.downtime = value
                    elif "施術頻度" in key or "頻度" in key:
                        overview.frequency = value
                    elif "メイク" in key:
                        overview.makeup = value
                    elif "入浴" in key or "シャワー" in key:
                        overview.bathing = value
                    elif "禁忌" in key or "注意" in key:
                        overview.contraindications = value
            
            content.overview = overview
    
    # 7. 症例写真 (CASES)
    cases_h3 = soup.find("h3", string=re.compile("症例"))
    if cases_h3:
        parent = cases_h3.find_parent()
        while parent and len(parent.find_all("img")) < 2:
            parent = parent.find_parent()
        
        if parent:
            # Before/After ペアを探す
            case_containers = parent.find_all("div", recursive=False)
            for container in case_containers:
                # BEFORE と AFTER を含むコンテナを探す
                before_text = container.find(string=re.compile("BEFORE"))
                after_text = container.find(string=re.compile("AFTER"))
                
                if before_text and after_text:
                    # 画像を取得
                    imgs = container.find_all("img")
                    before_img = None
                    after_img = None
                    before_desc = ""
                    after_desc = ""
                    
                    for img in imgs:
                        alt = img.get("alt", "").lower()
                        if "before" in alt:
                            before_img = urljoin(url, img.get("src", ""))
                        elif "after" in alt:
                            after_img = urljoin(url, img.get("src", ""))
                    
                    # 説明文を取得
                    for elem in container.stripped_strings:
                        text = str(elem).strip()
                        if text and text not in ["BEFORE", "AFTER"] and len(text) > 5:
                            if not before_desc and before_img:
                                before_desc = text
                            elif before_desc and not after_desc:
                                after_desc = text
                                break
                    
                    if before_img and after_img:
                        content.before_afters.append(BeforeAfter(
                            before_image_url=before_img,
                            after_image_url=after_img,
                            before_description=before_desc if before_desc else None,
                            after_description=after_desc if after_desc else None,
                            treatment_info=None
                        ))
    
    # 8. FAQ
    faq_h3 = soup.find("h3", string=re.compile("よくある質問"))
    if faq_h3:
        parent = faq_h3.find_parent()
        while parent and len(parent.find_all("button")) == 0:
            parent = parent.find_parent()
        
        if parent:
            buttons = parent.find_all("button")
            for i, btn in enumerate(buttons):
                question = btn.get_text(strip=True)
                # アイコンなどを除去
                question = re.sub(r'\s+', ' ', question).strip()
                if question and ("?" in question or "？" in question):
                    content.faqs.append(FAQ(
                        question=question,
                        answer=None,  # アコーディオン内なので取得困難
                        sort_order=i
                    ))
    
    # 取得結果をログ
    print(f"    [OK] Features:{len(content.features)} Recs:{len(content.recommendations)} FAQs:{len(content.faqs)} Cases:{len(content.before_afters)}")
    
    return content


def generate_uuid() -> str:
    """UUID生成"""
    return str(uuid.uuid4())[:8]


def to_dict(obj) -> dict:
    """データクラスを辞書に変換"""
    if hasattr(obj, "__dataclass_fields__"):
        return {k: to_dict(v) for k, v in asdict(obj).items()}
    elif isinstance(obj, list):
        return [to_dict(i) for i in obj]
    else:
        return obj


def generate_sql(services: list[ServiceContent], output_path: Path):
    """SQLシードファイルを生成"""
    lines = [
        "-- ============================================",
        "-- サービスコンテンツ シードデータ",
        f"-- 生成日時: {time.strftime('%Y-%m-%d %H:%M:%S')}",
        "-- ============================================",
        "",
    ]
    
    for svc in services:
        if not svc.name_ja:
            continue
        
        svc_id = generate_uuid()
        
        # service_contents
        lines.append(f"-- {svc.name_ja}")
        lines.append(f"""INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
VALUES (
    '{svc_id}',
    NULL, -- subcategory_idは後で紐付け
    '{escape_sql(svc.name_ja)}',
    {sql_str(svc.name_en)},
    '{escape_sql(svc.slug)}',
    '{escape_sql(svc.source_url)}',
    {sql_str(svc.about_subtitle)},
    {sql_str(svc.about_description)},
    {sql_str(svc.hero_image_url)},
    0,
    datetime('now')
);""")
        lines.append("")
        
        # service_features
        for feat in svc.features:
            feat_id = generate_uuid()
            lines.append(f"""INSERT INTO service_features (id, service_content_id, title, description, sort_order)
VALUES ('{feat_id}', '{svc_id}', '{escape_sql(feat.title)}', '{escape_sql(feat.description)}', {feat.sort_order});""")
        
        # service_recommendations
        for rec in svc.recommendations:
            rec_id = generate_uuid()
            lines.append(f"""INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
VALUES ('{rec_id}', '{svc_id}', '{escape_sql(rec.text)}', {rec.sort_order});""")
        
        # service_overviews
        if svc.overview:
            ov = svc.overview
            ov_id = generate_uuid()
            lines.append(f"""INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
VALUES ('{ov_id}', '{svc_id}', {sql_str(ov.duration)}, {sql_str(ov.downtime)}, {sql_str(ov.frequency)}, {sql_str(ov.makeup)}, {sql_str(ov.bathing)}, {sql_str(ov.contraindications)});""")
        
        # service_faqs
        for faq in svc.faqs:
            faq_id = generate_uuid()
            lines.append(f"""INSERT INTO service_faqs (id, service_content_id, question, answer, sort_order)
VALUES ('{faq_id}', '{svc_id}', '{escape_sql(faq.question)}', {sql_str(faq.answer)}, {faq.sort_order});""")
        
        lines.append("")
    
    output_path.write_text("\n".join(lines), encoding="utf-8")


def escape_sql(text: str) -> str:
    """SQL用エスケープ"""
    if not text:
        return ""
    return text.replace("'", "''")


def sql_str(value: Optional[str]) -> str:
    """NULL対応SQL文字列"""
    if value is None:
        return "NULL"
    return f"'{escape_sql(value)}'"


def main():
    print("=" * 50)
    print("レディアンクリニック サービススクレイパー")
    print("=" * 50)
    
    # 出力ディレクトリ作成
    output_dir = Path("data/scraped")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # サービス一覧取得
    service_list = scrape_service_list()
    
    # 各サービスをスクレイピング
    services: list[ServiceContent] = []
    
    for i, svc_info in enumerate(service_list):
        print(f"\n[{i+1}/{len(service_list)}] {svc_info['name']}")
        
        content = scrape_service_page(svc_info["url"], svc_info["category"])
        if content:
            # 名前を修正
            if not content.name_ja:
                content.name_ja = svc_info["name"]
            services.append(content)
        
        # 負荷軽減のため少し待機
        time.sleep(0.5)
    
    # JSON出力
    json_path = output_dir / "services.json"
    json_data = [to_dict(s) for s in services]
    json_path.write_text(json.dumps(json_data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\n[OK] JSON出力: {json_path}")
    
    # SQL出力
    sql_path = Path("database/d1/seed_service_content.sql")
    generate_sql(services, sql_path)
    print(f"[OK] SQL出力: {sql_path}")
    
    # サマリー
    print("\n" + "=" * 50)
    print("スクレイピング完了")
    print("=" * 50)
    print(f"  サービス数: {len(services)}")
    print(f"  特徴数: {sum(len(s.features) for s in services)}")
    print(f"  おすすめ数: {sum(len(s.recommendations) for s in services)}")
    print(f"  FAQ数: {sum(len(s.faqs) for s in services)}")
    print("")
    print("次のステップ:")
    print("  1. data/scraped/services.json を確認・編集")
    print("  2. マイグレーション適用: npx wrangler d1 migrations apply ...")
    print("  3. シードデータ投入")


if __name__ == "__main__":
    main()

