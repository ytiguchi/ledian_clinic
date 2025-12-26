#!/usr/bin/env python3
"""
レディアンクリニック 症例写真クローラー
各施術ページからBefore/After写真を収集

Usage:
    python scripts/scrape_before_afters.py

Output:
    - data/scraped/before_afters.json (構造化されたデータ)
    - database/d1/seed_before_afters.sql (SQLシード)
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
import hashlib
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional, List
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
class BeforeAfterCase:
    """症例写真データ（Before/Afterペアまたは単体画像）"""
    before_image_url: str  # 単体の場合は空文字列
    after_image_url: str   # 単体の場合はこれがメイン画像
    treatment_name: str
    treatment_slug: str
    category_name: Optional[str] = None
    caption: Optional[str] = None
    patient_age: Optional[int] = None
    patient_gender: Optional[str] = None
    treatment_count: Optional[int] = None
    treatment_period: Optional[str] = None
    source_url: str = ""
    case_type: str = "before_after"  # "before_after" or "single"
    
    def get_id(self) -> str:
        """一意IDを生成（画像URLベース）"""
        content = f"{self.before_image_url}:{self.after_image_url}"
        return hashlib.md5(content.encode()).hexdigest()[:16]


# ============================================
# スクレイパー
# ============================================

BASE_URL = "https://ledianclinic.jp"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
}


def get_soup(url: str) -> Optional[BeautifulSoup]:
    """URLからBeautifulSoupオブジェクトを取得"""
    print(f"  [FETCH] {url}")
    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        response.raise_for_status()
        return BeautifulSoup(response.text, "html.parser")
    except Exception as e:
        print(f"    [ERROR] {e}")
        return None


def extract_slug(url: str) -> str:
    """URLからスラッグを抽出（URLデコード済み）"""
    from urllib.parse import unquote
    # /service/potenza/ -> potenza
    match = re.search(r"/service/([^/]+)/?$", url)
    if match:
        # URLエンコードされた日本語をデコード
        slug = unquote(match.group(1))
        # 日本語の場合は英語スラグに変換するマッピング
        slug_map = {
            'オリジオkiss': 'origio-kiss',
            'ショッピングリフト': 'shopping-lift',
        }
        return slug_map.get(slug.lower(), slug)
    return ""


def get_all_service_urls() -> List[dict]:
    """サービス一覧ページからすべてのサービスURLを取得"""
    print("[INFO] サービス一覧を取得中...")
    soup = get_soup(f"{BASE_URL}/service")
    if not soup:
        return []
    
    services = []
    current_category = ""
    
    # h4 カテゴリとその下のリンクを取得
    main_content = soup.find("main") or soup.find("body")
    
    for h4 in main_content.find_all("h4"):
        current_category = h4.get_text(strip=True)
        
        # h4の親要素からサービスリンクを探す
        parent = h4.find_parent()
        if parent:
            for link in parent.find_all("a", href=True):
                url = link.get("href", "")
                if "/service/" in url and url not in ["/service/", "/service"]:
                    name = link.get_text(strip=True)
                    if name and len(name) < 50:
                        full_url = urljoin(BASE_URL, url)
                        services.append({
                            "name": name,
                            "url": full_url,
                            "category": current_category,
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


def parse_treatment_info(text: str) -> dict:
    """施術回数・期間・年齢などを解析"""
    info = {}
    
    # 回数（例: "1回" "3回施術")
    count_match = re.search(r'(\d+)\s*回', text)
    if count_match:
        info['count'] = int(count_match.group(1))
    
    # 期間（例: "3ヶ月" "1年")
    period_match = re.search(r'(\d+\s*(ヶ月|か月|カ月|年|週間|日))', text)
    if period_match:
        info['period'] = period_match.group(1)
    
    # 年齢（例: "30代" "40歳")
    age_match = re.search(r'(\d+)\s*(歳|代)', text)
    if age_match:
        age = int(age_match.group(1))
        if age_match.group(2) == '代':
            age = age + 5  # 30代なら35歳として記録
        info['age'] = age
    
    # 性別
    if '女性' in text or '♀' in text:
        info['gender'] = '女性'
    elif '男性' in text or '♂' in text:
        info['gender'] = '男性'
    
    return info


def scrape_before_afters(url: str, treatment_name: str, treatment_slug: str, category_name: str) -> List[BeforeAfterCase]:
    """施術ページから症例写真を抽出"""
    soup = get_soup(url)
    if not soup:
        return []
    
    cases = []
    
    # 症例セクションを探す（複数のパターンに対応）
    cases_section = None
    
    # パターン1: class名で探す
    for class_name in ['cases', 'case', 'before-after', 'beforeafter', 'gallery']:
        cases_section = soup.find('section', class_=re.compile(class_name, re.I))
        if cases_section:
            break
        cases_section = soup.find('div', class_=re.compile(class_name, re.I))
        if cases_section:
            break
    
    # パターン2: h3/h2 で探す
    if not cases_section:
        for header in soup.find_all(['h2', 'h3']):
            header_text = header.get_text(strip=True)
            if any(keyword in header_text for keyword in ['症例', 'CASE', 'ビフォー', 'Before', 'before']):
                cases_section = header.find_parent('section') or header.find_parent('div')
                if cases_section:
                    break
    
    # パターン3: 全ページから BEFORE/AFTER ペアを探す
    search_area = cases_section or soup
    
    # 方法1: Before/After の画像ペアを探す
    for container in search_area.find_all(['div', 'figure', 'li'], recursive=True):
        # BEFORE と AFTER のテキストがあるか確認
        container_text = container.get_text(strip=True).upper()
        has_before = 'BEFORE' in container_text or 'ビフォー' in container_text
        has_after = 'AFTER' in container_text or 'アフター' in container_text
        
        if has_before and has_after:
            images = container.find_all('img')
            if len(images) >= 2:
                before_img = None
                after_img = None
                
                for img in images:
                    src = img.get('src') or img.get('data-src') or ''
                    alt = (img.get('alt') or '').lower()
                    srcset = (img.get('srcset') or '').lower()
                    
                    if not src:
                        continue
                    
                    # before 画像を判定
                    if 'before' in alt or 'before' in src.lower() or 'ビフォー' in alt:
                        before_img = urljoin(url, src)
                    # after 画像を判定
                    elif 'after' in alt or 'after' in src.lower() or 'アフター' in alt:
                        after_img = urljoin(url, src)
                    # 順序で判定（最初がBefore、次がAfter）
                    elif not before_img:
                        before_img = urljoin(url, src)
                    elif not after_img:
                        after_img = urljoin(url, src)
                
                if before_img and after_img:
                    # 治療情報を取得
                    caption = ""
                    info_text = container.get_text(strip=True)
                    
                    # BEFORE, AFTER以外のテキストをキャプションとして取得
                    for text_elem in container.stripped_strings:
                        text = str(text_elem).strip()
                        if text.upper() not in ['BEFORE', 'AFTER', 'ビフォー', 'アフター'] and len(text) > 5:
                            caption = text
                            break
                    
                    treatment_info = parse_treatment_info(info_text)
                    
                    case = BeforeAfterCase(
                        before_image_url=before_img,
                        after_image_url=after_img,
                        treatment_name=treatment_name,
                        treatment_slug=treatment_slug,
                        category_name=category_name,
                        caption=caption if caption else None,
                        patient_age=treatment_info.get('age'),
                        patient_gender=treatment_info.get('gender'),
                        treatment_count=treatment_info.get('count'),
                        treatment_period=treatment_info.get('period'),
                        source_url=url
                    )
                    
                    # 重複チェック
                    if not any(c.before_image_url == case.before_image_url for c in cases):
                        cases.append(case)
    
    # 方法2: 画像のalt属性やファイル名からペアを推測
    if not cases:
        all_images = search_area.find_all('img')
        before_images = []
        after_images = []
        
        for img in all_images:
            src = img.get('src') or img.get('data-src') or ''
            alt = (img.get('alt') or '').lower()
            
            if not src or 'icon' in src.lower() or 'logo' in src.lower():
                continue
            
            full_url = urljoin(url, src)
            
            if 'before' in alt or 'before' in src.lower():
                before_images.append(full_url)
            elif 'after' in alt or 'after' in src.lower():
                after_images.append(full_url)
        
        # Before/Afterをペアにする
        for i, before in enumerate(before_images):
            if i < len(after_images):
                case = BeforeAfterCase(
                    before_image_url=before,
                    after_image_url=after_images[i],
                    treatment_name=treatment_name,
                    treatment_slug=treatment_slug,
                    category_name=category_name,
                    source_url=url
                )
                cases.append(case)
    
    # 方法3: 1カラム症例（case-item--1column）を探す
    case_items = soup.find_all('div', class_=re.compile(r'case-item'))
    for item in case_items:
        img = item.find('img')
        if not img:
            continue
        
        src = img.get('src') or img.get('data-src') or ''
        alt = img.get('alt') or ''
        
        # アイコンやロゴは除外
        if not src or 'icon' in src.lower() or 'logo' in src.lower() or 'arrow' in src.lower():
            continue
        
        # 既に追加済みの画像は除外
        full_url = urljoin(url, src)
        if any(c.after_image_url == full_url or c.before_image_url == full_url for c in cases):
            continue
        
        # 説明文を取得
        desc_elem = item.find('div', class_=re.compile(r'case-item__desc'))
        caption = ""
        treatment_info = {}
        
        if desc_elem:
            # HTMLを取得してテキストに変換（改行を保持）
            desc_html = str(desc_elem)
            # <br>タグを改行に変換
            desc_text = desc_html.replace('<br>', '\n').replace('<br/>', '\n').replace('<br />', '\n')
            # その他のHTMLタグを除去
            import re as regex
            desc_text = regex.sub(r'<[^>]+>', '', desc_text)
            desc_text = desc_text.strip()
            
            # フル情報をキャプションとして保存（切らない）
            caption = desc_text if desc_text else ""
            treatment_info = parse_treatment_info(desc_text)
        
        case = BeforeAfterCase(
            before_image_url="",  # 単体画像
            after_image_url=full_url,
            treatment_name=treatment_name,
            treatment_slug=treatment_slug,
            category_name=category_name,
            caption=caption if caption else None,
            patient_age=treatment_info.get('age'),
            patient_gender=treatment_info.get('gender'),
            treatment_count=treatment_info.get('count'),
            treatment_period=treatment_info.get('period'),
            source_url=url,
            case_type="single"
        )
        cases.append(case)
    
    return cases


def to_dict(obj) -> dict:
    """データクラスを辞書に変換"""
    if hasattr(obj, "__dataclass_fields__"):
        return {k: to_dict(v) for k, v in asdict(obj).items()}
    elif isinstance(obj, list):
        return [to_dict(i) for i in obj]
    else:
        return obj


def escape_sql(text: str) -> str:
    """SQL用エスケープ"""
    if not text:
        return ""
    return text.replace("'", "''").replace("\n", " ").replace("\r", "")


def sql_str(value) -> str:
    """NULL対応SQL文字列"""
    if value is None:
        return "NULL"
    if isinstance(value, int):
        return str(value)
    return f"'{escape_sql(str(value))}'"


def generate_sql(cases: List[BeforeAfterCase], output_path: Path):
    """SQLシードファイルを生成"""
    before_after_cases = [c for c in cases if c.case_type == "before_after"]
    single_cases = [c for c in cases if c.case_type == "single"]
    
    lines = [
        "-- ============================================",
        "-- 症例写真 シードデータ",
        f"-- 生成日時: {time.strftime('%Y-%m-%d %H:%M:%S')}",
        f"-- Before/After: {len(before_after_cases)}件",
        f"-- 単体画像: {len(single_cases)}件",
        f"-- 合計: {len(cases)}件",
        "-- ============================================",
        "",
        "-- 注意: treatment_id は実際のDBのIDに置き換える必要があります",
        "-- subcategory_id を使用する場合はカラム名を変更してください",
        "",
    ]
    
    # 施術ごとにグループ化
    by_treatment = {}
    for case in cases:
        slug = case.treatment_slug
        if slug not in by_treatment:
            by_treatment[slug] = []
        by_treatment[slug].append(case)
    
    for slug, treatment_cases in by_treatment.items():
        ba_count = len([c for c in treatment_cases if c.case_type == "before_after"])
        single_count = len([c for c in treatment_cases if c.case_type == "single"])
        lines.append(f"-- {treatment_cases[0].treatment_name} ({slug}) - B/A:{ba_count}件, 単体:{single_count}件")
        
        for i, case in enumerate(treatment_cases):
            case_id = case.get_id()
            before_url = case.before_image_url if case.before_image_url else ""
            
            lines.append(f"""INSERT INTO treatment_before_afters (
    id, subcategory_id, before_image_url, after_image_url, 
    caption, patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order
) VALUES (
    '{case_id}',
    (SELECT id FROM subcategories WHERE slug = '{escape_sql(slug)}' LIMIT 1),
    '{escape_sql(before_url)}',
    '{escape_sql(case.after_image_url)}',
    {sql_str(case.caption)},
    {sql_str(case.patient_age)},
    {sql_str(case.patient_gender)},
    {sql_str(case.treatment_count)},
    {sql_str(case.treatment_period)},
    1,
    {i}
);""")
        lines.append("")
    
    output_path.write_text("\n".join(lines), encoding="utf-8")


def main():
    print("=" * 60)
    print("レディアンクリニック 症例写真クローラー")
    print("=" * 60)
    
    # 出力ディレクトリ作成
    output_dir = Path("data/scraped")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # サービス一覧取得
    service_list = get_all_service_urls()
    
    # 各サービスから症例写真を収集
    all_cases: List[BeforeAfterCase] = []
    
    for i, svc_info in enumerate(service_list):
        print(f"\n[{i+1}/{len(service_list)}] {svc_info['name']} ({svc_info['slug']})")
        
        cases = scrape_before_afters(
            svc_info["url"],
            svc_info["name"],
            svc_info["slug"],
            svc_info["category"]
        )
        
        if cases:
            print(f"    [OK] {len(cases)} 件の症例写真を発見")
            all_cases.extend(cases)
        else:
            print(f"    [--] 症例写真なし")
        
        # 負荷軽減のため少し待機
        time.sleep(0.5)
    
    # JSON出力
    json_path = output_dir / "before_afters.json"
    before_after_count = len([c for c in all_cases if c.case_type == "before_after"])
    single_count = len([c for c in all_cases if c.case_type == "single"])
    
    json_data = {
        "total": len(all_cases),
        "before_after_count": before_after_count,
        "single_count": single_count,
        "by_treatment": {},
        "cases": [to_dict(c) for c in all_cases]
    }
    
    # 施術ごとにグループ化
    for case in all_cases:
        slug = case.treatment_slug
        if slug not in json_data["by_treatment"]:
            json_data["by_treatment"][slug] = {
                "treatment_name": case.treatment_name,
                "category": case.category_name,
                "before_after": 0,
                "single": 0,
                "total": 0
            }
        json_data["by_treatment"][slug]["total"] += 1
        if case.case_type == "before_after":
            json_data["by_treatment"][slug]["before_after"] += 1
        else:
            json_data["by_treatment"][slug]["single"] += 1
    
    json_path.write_text(json.dumps(json_data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\n[OK] JSON出力: {json_path}")
    
    # SQL出力
    sql_path = Path("database/d1/seed_before_afters.sql")
    generate_sql(all_cases, sql_path)
    print(f"[OK] SQL出力: {sql_path}")
    
    # サマリー
    print("\n" + "=" * 60)
    print("クローリング完了")
    print("=" * 60)
    print(f"  総症例写真数: {len(all_cases)}")
    print(f"    - Before/After: {before_after_count}件")
    print(f"    - 単体画像: {single_count}件")
    print(f"  施術数: {len(json_data['by_treatment'])}")
    print("")
    print("施術別内訳:")
    for slug, info in sorted(json_data["by_treatment"].items(), key=lambda x: -x[1]["total"]):
        ba = info['before_after']
        sg = info['single']
        print(f"  - {info['treatment_name']}: {info['total']}件 (B/A:{ba}, 単体:{sg})")
    print("")
    print("次のステップ:")
    print("  1. data/scraped/before_afters.json を確認")
    print("  2. database/d1/seed_before_afters.sql を確認・編集")
    print("  3. treatment_id を実際のDBのIDに紐付け")
    print("  4. シードデータ投入")


if __name__ == "__main__":
    main()

