#!/usr/bin/env python3
"""
手動紐付けスクリプト
指定されたURLをスクレイピングして、対応するサブカテゴリに紐付ける
"""

import sys
import io

# Windows cp932 encoding fix
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

import sqlite3
import uuid
import re
import time
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional, List

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    print("[ERROR] requests, beautifulsoup4 をインストールしてください")
    print("pip install requests beautifulsoup4")
    exit(1)

# DB path
DB_PATH = Path("apps/internal-site/.wrangler/state/v3/d1/miniflare-D1DatabaseObject")

def find_db_file():
    """Find the SQLite database file"""
    if not DB_PATH.exists():
        print(f"[ERROR] DB path not found: {DB_PATH}")
        return None
    
    for f in DB_PATH.glob("*.sqlite"):
        return f
    return None

@dataclass
class Feature:
    title: str
    description: str
    sort_order: int = 0

@dataclass
class Recommendation:
    text: str
    sort_order: int = 0

@dataclass
class Overview:
    duration: Optional[str] = None
    downtime: Optional[str] = None
    frequency: Optional[str] = None
    makeup: Optional[str] = None
    bathing: Optional[str] = None
    contraindications: Optional[str] = None

@dataclass
class FAQ:
    question: str
    answer: Optional[str] = None
    sort_order: int = 0

@dataclass
class ServiceContent:
    name_ja: str
    name_en: Optional[str]
    slug: str
    source_url: str
    about_subtitle: Optional[str] = None
    about_description: Optional[str] = None
    hero_image_url: Optional[str] = None
    features: List[Feature] = field(default_factory=list)
    recommendations: List[Recommendation] = field(default_factory=list)
    overview: Optional[Overview] = None
    faqs: List[FAQ] = field(default_factory=list)

def scrape_service_page(url: str) -> Optional[ServiceContent]:
    """Scrape a service page"""
    print(f"[SCRAPE] {url}")
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    
    try:
        resp = requests.get(url, headers=headers, timeout=30)
        resp.raise_for_status()
        resp.encoding = 'utf-8'
    except Exception as e:
        print(f"[ERROR] Failed to fetch {url}: {e}")
        return None
    
    soup = BeautifulSoup(resp.text, 'html.parser')
    
    # Extract name
    h1 = soup.find('h1')
    name_ja = h1.get_text(strip=True) if h1 else "Unknown"
    
    h2 = soup.find('h2')
    name_en = h2.get_text(strip=True) if h2 else None
    
    # Slug from URL
    slug = url.rstrip('/').split('/')[-1]
    
    content = ServiceContent(
        name_ja=name_ja,
        name_en=name_en,
        slug=slug,
        source_url=url
    )
    
    # About description
    about_section = soup.find('h3', string=re.compile('ABOUT'))
    if about_section:
        parent = about_section.find_parent()
        if parent:
            h4 = parent.find('h4')
            if h4:
                content.about_subtitle = h4.get_text(strip=True)
            p = parent.find('p')
            if p:
                content.about_description = p.get_text(strip=True)
    
    # Features
    features_h2 = soup.find('h2', string=re.compile('特徴'))
    if features_h2:
        parent = features_h2.find_parent()
        if parent:
            h4_list = parent.find_all('h4')
            for i, h4 in enumerate(h4_list):
                title = h4.get_text(strip=True)
                desc = ""
                next_p = h4.find_next('p')
                if next_p and next_p.find_parent() == h4.find_parent():
                    desc = next_p.get_text(strip=True)
                content.features.append(Feature(title=title, description=desc, sort_order=i))
    
    # Recommendations
    recommend_h3 = soup.find('h3', string=re.compile('おすすめ'))
    if recommend_h3:
        parent = recommend_h3.find_parent()
        if parent:
            for i, p in enumerate(parent.find_all('p')):
                text = p.get_text(strip=True)
                if text and text != 'RECOMMEND' and len(text) < 100 and len(text) > 3:
                    content.recommendations.append(Recommendation(text=text, sort_order=i))
    
    # Overview table
    overview_h3 = soup.find('h3', string=re.compile('施術概要'))
    if overview_h3:
        table = overview_h3.find_next('table')
        if table:
            overview = Overview()
            for row in table.find_all('tr'):
                cells = row.find_all(['th', 'td'])
                if len(cells) >= 2:
                    key = cells[0].get_text(strip=True)
                    value = cells[1].get_text(strip=True)
                    if '施術時間' in key:
                        overview.duration = value
                    elif 'ダウンタイム' in key:
                        overview.downtime = value
                    elif '施術頻度' in key or '頻度' in key:
                        overview.frequency = value
                    elif 'メイク' in key:
                        overview.makeup = value
                    elif '入浴' in key:
                        overview.bathing = value
                    elif '禁忌' in key:
                        overview.contraindications = value
            content.overview = overview
    
    # FAQs
    faq_h3 = soup.find('h3', string=re.compile('よくある質問'))
    if faq_h3:
        parent = faq_h3.find_parent()
        if parent:
            h3_list = parent.find_all('h3')
            for i, h3 in enumerate(h3_list):
                q = h3.get_text(strip=True)
                if q and '?' in q or 'ですか' in q or 'ますか' in q:
                    content.faqs.append(FAQ(question=q, answer=None, sort_order=i))
    
    return content

def escape_sql(s: Optional[str]) -> str:
    if s is None:
        return ""
    return s.replace("'", "''")

def sql_str(s: Optional[str]) -> str:
    if s is None:
        return "NULL"
    return f"'{escape_sql(s)}'"

def main():
    print("=" * 60)
    print("手動紐付けスクリプト")
    print("=" * 60)
    
    # 紐付け対象
    manual_links = [
        {
            "url": "https://ledianclinic.jp/service/high-intensity-focused-ultrasound/",
            "subcategory_name": "ハイフ"
        },
        {
            "url": "https://ledianclinic.jp/service/permanent-makeup/",
            "subcategory_name": "眉"  # アートメイクカテゴリ配下の代表サブカテゴリ
        },
        {
            "url": "https://ledianclinic.jp/service/soprano-ice-platinum/",
            "subcategory_name": "ソプラノプラチナム"  # 医療脱毛カテゴリ配下
        }
    ]
    
    db_file = find_db_file()
    if not db_file:
        print("[ERROR] Database file not found")
        return
    
    print(f"[INFO] DB: {db_file}")
    
    conn = sqlite3.connect(db_file)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    # Get subcategories
    cursor.execute("SELECT id, name, slug FROM subcategories WHERE is_active = 1")
    subcategories = {row['name']: row['id'] for row in cursor.fetchall()}
    
    print(f"[INFO] サブカテゴリ: {len(subcategories)}件")
    
    success_count = 0
    
    for item in manual_links:
        url = item["url"]
        target_subcat = item["subcategory_name"]
        
        # Find subcategory ID
        subcat_id = subcategories.get(target_subcat)
        if not subcat_id:
            print(f"[WARN] サブカテゴリが見つかりません: {target_subcat}")
            # Try partial match
            for name, sid in subcategories.items():
                if target_subcat in name or name in target_subcat:
                    subcat_id = sid
                    print(f"  -> 部分一致で発見: {name}")
                    break
        
        if not subcat_id:
            print(f"[SKIP] {target_subcat} の紐付け先が見つかりません")
            continue
        
        # Check if already exists
        cursor.execute("SELECT id FROM service_contents WHERE source_url = ?", (url,))
        existing = cursor.fetchone()
        
        if existing:
            # Update existing
            cursor.execute(
                "UPDATE service_contents SET subcategory_id = ?, is_published = 1 WHERE id = ?",
                (subcat_id, existing['id'])
            )
            print(f"[UPDATE] 既存レコードを更新: {url} -> {target_subcat}")
            success_count += 1
            continue
        
        # Scrape and insert
        content = scrape_service_page(url)
        if not content:
            print(f"[ERROR] スクレイピング失敗: {url}")
            continue
        
        time.sleep(1)  # Rate limiting
        
        # Insert service_content
        svc_id = str(uuid.uuid4())
        cursor.execute("""
            INSERT INTO service_contents (id, subcategory_id, name_ja, name_en, slug, source_url, about_subtitle, about_description, hero_image_url, is_published, scraped_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, datetime('now'))
        """, (
            svc_id,
            subcat_id,
            content.name_ja,
            content.name_en,
            content.slug,
            content.source_url,
            content.about_subtitle,
            content.about_description,
            content.hero_image_url
        ))
        
        # Insert features
        for f in content.features:
            cursor.execute("""
                INSERT INTO service_features (id, service_content_id, title, description, sort_order)
                VALUES (?, ?, ?, ?, ?)
            """, (str(uuid.uuid4()), svc_id, f.title, f.description, f.sort_order))
        
        # Insert recommendations
        for r in content.recommendations:
            cursor.execute("""
                INSERT INTO service_recommendations (id, service_content_id, text, sort_order)
                VALUES (?, ?, ?, ?)
            """, (str(uuid.uuid4()), svc_id, r.text, r.sort_order))
        
        # Insert overview
        if content.overview:
            cursor.execute("""
                INSERT INTO service_overviews (id, service_content_id, duration, downtime, frequency, makeup, bathing, contraindications)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                str(uuid.uuid4()),
                svc_id,
                content.overview.duration,
                content.overview.downtime,
                content.overview.frequency,
                content.overview.makeup,
                content.overview.bathing,
                content.overview.contraindications
            ))
        
        # Insert FAQs
        for faq in content.faqs:
            cursor.execute("""
                INSERT INTO service_faqs (id, service_content_id, question, answer, sort_order)
                VALUES (?, ?, ?, ?, ?)
            """, (str(uuid.uuid4()), svc_id, faq.question, faq.answer, faq.sort_order))
        
        print(f"[INSERT] 新規追加: {content.name_ja} -> {target_subcat}")
        print(f"  Features: {len(content.features)}, Recommendations: {len(content.recommendations)}, FAQs: {len(content.faqs)}")
        success_count += 1
    
    conn.commit()
    conn.close()
    
    print("")
    print("=" * 60)
    print(f"[DONE] {success_count}/{len(manual_links)} 件の紐付け完了")
    print("=" * 60)

if __name__ == "__main__":
    main()

