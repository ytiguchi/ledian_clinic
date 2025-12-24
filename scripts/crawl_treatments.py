#!/usr/bin/env python3
"""
Ledian Clinic 施術ページクローラー
教育コンテンツを抽出してJSONに保存
"""

import requests
from bs4 import BeautifulSoup
import json
import re
import time
from urllib.parse import urljoin, unquote
import os

BASE_URL = "https://ledianclinic.jp"
SERVICE_URL = f"{BASE_URL}/service/"

# 出力ディレクトリ
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "data", "content", "treatments", "crawled")
os.makedirs(OUTPUT_DIR, exist_ok=True)

def get_soup(url):
    """URLからBeautifulSoupオブジェクトを取得"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
    }
    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        return BeautifulSoup(response.text, 'html.parser')
    except Exception as e:
        print(f"Error fetching {url}: {e}")
        return None

def clean_text(text):
    """テキストをクリーンアップ"""
    if not text:
        return ""
    # 改行とスペースを正規化
    text = re.sub(r'\s+', ' ', text.strip())
    return text

def extract_list_items(container):
    """リストアイテムを抽出"""
    items = []
    if container:
        for li in container.find_all('li'):
            text = clean_text(li.get_text())
            if text:
                items.append(text)
        # p タグも確認
        for p in container.find_all('p'):
            text = clean_text(p.get_text())
            if text and text not in items:
                items.append(text)
    return items

def extract_faq(soup):
    """FAQを抽出"""
    faqs = []
    faq_section = soup.find('section', class_='faq') or soup.find('div', class_='faq')
    if not faq_section:
        # h3でFAQを探す
        faq_header = soup.find('h3', class_='faq__ja')
        if faq_header:
            faq_section = faq_header.find_parent('section') or faq_header.find_parent('div')
    
    if faq_section:
        # schema.orgのFAQを探す
        faq_items = faq_section.find_all('div', itemtype=re.compile(r'Question'))
        if faq_items:
            for item in faq_items:
                q_elem = item.find(itemprop='name')
                a_elem = item.find(itemprop='text')
                if q_elem and a_elem:
                    faqs.append({
                        'question': clean_text(q_elem.get_text()),
                        'answer': clean_text(a_elem.get_text())
                    })
        else:
            # 一般的なFAQ構造を探す
            q_elements = faq_section.find_all(['h3', 'h4', 'dt'])
            for q in q_elements:
                q_text = clean_text(q.get_text())
                if q_text and '?' in q_text or '？' in q_text:
                    # 次の要素を回答として取得
                    next_elem = q.find_next_sibling(['p', 'dd', 'div'])
                    if next_elem:
                        faqs.append({
                            'question': q_text,
                            'answer': clean_text(next_elem.get_text())
                        })
    return faqs

def extract_treatment_overview(soup):
    """施術概要を抽出"""
    overview = {}
    
    # 施術時間、頻度、注意事項などのテーブルを探す
    overview_section = soup.find('section', class_='overview') or soup.find('div', class_='overview')
    if not overview_section:
        overview_header = soup.find('h3', class_='overview__ja')
        if overview_header:
            overview_section = overview_header.find_parent('section') or overview_header.find_parent('div')
    
    if overview_section:
        # テーブルから情報を抽出
        table = overview_section.find('table')
        if table:
            rows = table.find_all('tr')
            for row in rows:
                cells = row.find_all(['th', 'td'])
                if len(cells) >= 2:
                    key = clean_text(cells[0].get_text())
                    value = clean_text(cells[1].get_text())
                    if key and value:
                        overview[key] = value
    
    return overview

def extract_features(soup):
    """特徴を抽出"""
    features = []
    
    features_section = soup.find('section', class_='features') or soup.find('div', class_='features')
    if not features_section:
        features_header = soup.find('h2', class_='features__ja')
        if features_header:
            features_section = features_header.find_parent('section') or features_header.find_parent('div')
    
    if features_section:
        items = features_section.find_all('div', class_=re.compile(r'features__item'))
        for item in items:
            title = item.find(['h4', 'h3'], class_=re.compile(r'title'))
            desc = item.find('p', class_=re.compile(r'desc'))
            if title:
                feature = {
                    'title': clean_text(title.get_text()),
                    'description': clean_text(desc.get_text()) if desc else ''
                }
                features.append(feature)
    
    return features

def extract_recommend(soup):
    """おすすめの方を抽出"""
    recommend = []
    
    recommend_section = soup.find('section', class_='recommend') or soup.find('div', class_='recommend')
    if not recommend_section:
        recommend_header = soup.find('h3', class_='recommend__ja')
        if recommend_header:
            recommend_section = recommend_header.find_parent('section') or recommend_header.find_parent('div')
    
    if recommend_section:
        items = recommend_section.find_all('li')
        for item in items:
            p = item.find('p')
            text = clean_text(p.get_text() if p else item.get_text())
            if text:
                recommend.append(text)
    
    return recommend

def scrape_treatment_page(url):
    """施術ページをスクレイピング"""
    print(f"Scraping: {url}")
    soup = get_soup(url)
    if not soup:
        return None
    
    treatment = {
        'url': url,
        'slug': url.rstrip('/').split('/')[-1]
    }
    
    # タイトル（日本語名）
    h1 = soup.find('h1')
    if h1:
        treatment['name_ja'] = clean_text(h1.get_text())
    
    # 英語名
    h2 = soup.find('h2')
    if h2 and h1:
        # h1の直後のh2を英語名として取得
        next_h2 = h1.find_next('h2')
        if next_h2:
            treatment['name_en'] = clean_text(next_h2.get_text())
    
    # メタ description
    meta_desc = soup.find('meta', {'name': 'description'})
    if meta_desc:
        treatment['meta_description'] = meta_desc.get('content', '')
    
    # JSON-LD から description を取得
    scripts = soup.find_all('script', type='application/ld+json')
    for script in scripts:
        try:
            data = json.loads(script.string)
            if isinstance(data, dict) and 'description' in data:
                treatment['description'] = data['description']
                break
        except:
            pass
    
    # 施術概要（firstview__description）
    firstview_desc = soup.find('div', class_='firstview__description-text')
    if firstview_desc:
        treatment['about'] = clean_text(firstview_desc.get_text())
    
    # 特徴
    features = extract_features(soup)
    if features:
        treatment['features'] = features
    
    # おすすめの方
    recommend = extract_recommend(soup)
    if recommend:
        treatment['recommended_for'] = recommend
    
    # 施術概要テーブル
    overview = extract_treatment_overview(soup)
    if overview:
        treatment['overview'] = overview
    
    # FAQ
    faqs = extract_faq(soup)
    if faqs:
        treatment['faqs'] = faqs
    
    return treatment

def get_all_service_urls():
    """すべての施術ページURLを取得"""
    soup = get_soup(SERVICE_URL)
    if not soup:
        return []
    
    urls = set()
    for a in soup.find_all('a', href=True):
        href = a['href']
        if '/service/' in href and href != SERVICE_URL:
            full_url = urljoin(BASE_URL, href)
            # フラグメント（#）を除去
            full_url = full_url.split('#')[0]
            if full_url.startswith(f"{BASE_URL}/service/") and full_url != f"{BASE_URL}/service/":
                urls.add(full_url)
    
    return sorted(list(urls))

def main():
    print("=" * 60)
    print("Ledian Clinic 施術ページクローラー")
    print("=" * 60)
    
    # すべての施術ページURLを取得
    print("\n施術ページURLを取得中...")
    urls = get_all_service_urls()
    print(f"見つかったページ: {len(urls)}件")
    
    # 各ページをスクレイピング
    all_treatments = []
    for i, url in enumerate(urls, 1):
        print(f"\n[{i}/{len(urls)}] ", end="")
        treatment = scrape_treatment_page(url)
        if treatment:
            all_treatments.append(treatment)
            
            # 個別ファイルも保存
            slug = treatment.get('slug', f'treatment_{i}')
            individual_path = os.path.join(OUTPUT_DIR, f"{slug}.json")
            with open(individual_path, 'w', encoding='utf-8') as f:
                json.dump(treatment, f, ensure_ascii=False, indent=2)
        
        # 礼儀正しくリクエスト間隔を空ける
        time.sleep(0.5)
    
    # 全施術データを1つのファイルに保存
    all_data_path = os.path.join(OUTPUT_DIR, "_all_treatments.json")
    with open(all_data_path, 'w', encoding='utf-8') as f:
        json.dump({
            'total': len(all_treatments),
            'treatments': all_treatments
        }, f, ensure_ascii=False, indent=2)
    
    print("\n" + "=" * 60)
    print(f"完了！ {len(all_treatments)}件の施術データを抽出しました")
    print(f"保存先: {OUTPUT_DIR}")
    print("=" * 60)

if __name__ == "__main__":
    main()

