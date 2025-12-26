#!/usr/bin/env python3
"""
症例写真データの正規化スクリプト
1. captionから【医療内容】【治療期間・回数】【費用】【リスク・副作用】を抽出
2. 外部画像URLをダウンロードしてR2にアップロード
3. DBを更新

使用方法:
  python scripts/migrate_before_afters.py --dry-run  # 確認のみ
  python scripts/migrate_before_afters.py            # 実行
"""

import re
import json
import subprocess
import sys
import argparse
import urllib.request
import urllib.parse
import os
import hashlib
from pathlib import Path


def run_d1_query(query: str, remote: bool = True) -> dict:
    """D1クエリを実行してJSONを返す"""
    cmd = [
        "npx", "wrangler", "d1", "execute", "DB",
        "--json",
        "--command", query
    ]
    if remote:
        cmd.insert(4, "--remote")
    
    result = subprocess.run(
        cmd,
        cwd=Path(__file__).parent.parent / "apps" / "internal-site",
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print(f"Error: {result.stderr}", file=sys.stderr)
        return {}
    
    try:
        # wrangler d1 --json の出力をパース
        output = result.stdout.strip()
        # 最初の[から最後の]までを取得
        start = output.find('[')
        end = output.rfind(']') + 1
        if start >= 0 and end > start:
            json_str = output[start:end]
            data = json.loads(json_str)
            if isinstance(data, list) and len(data) > 0:
                return data[0]
            return data
        return {}
    except json.JSONDecodeError as e:
        print(f"JSON parse error: {e}", file=sys.stderr)
        print(f"Output: {result.stdout[:500]}", file=sys.stderr)
        return {}


def parse_caption(caption: str) -> dict:
    """captionから【セクション】を抽出"""
    if not caption:
        return {
            'treatment_content': None,
            'treatment_duration': None,
            'treatment_cost_text': None,
            'risks': None,
            'remaining': None
        }
    
    # 改行を正規化
    text = caption.replace('\\r\\n', '\n').replace('\\n', '\n').replace('\r\n', '\n')
    
    treatment_content = None
    treatment_duration = None
    treatment_cost_text = None
    risks = None
    
    # 【医療内容】または【治療内容】を抽出
    match = re.search(r'【(?:医療内容|治療内容)】\s*([\s\S]*?)(?=【|$)', text)
    if match:
        treatment_content = match.group(1).strip()
    
    # 【治療期間・回数】等を抽出
    match = re.search(r'【(?:治療期間・回数|期間・回数|治療期間|期間|回数)】\s*([\s\S]*?)(?=【|$)', text)
    if match:
        treatment_duration = match.group(1).strip()
    
    # 【費用】を抽出
    match = re.search(r'【費用】\s*([\s\S]*?)(?=【|$)', text)
    if match:
        treatment_cost_text = match.group(1).strip()
    
    # 【リスク・副作用】を抽出
    match = re.search(r'【リスク[・／]?副作用】\s*([\s\S]*?)(?=【|$)', text)
    if match:
        risks = match.group(1).strip()
    
    # 抽出済みセクションを除いた残り
    remaining = text
    remaining = re.sub(r'【(?:医療内容|治療内容)】[\s\S]*?(?=【|$)', '', remaining)
    remaining = re.sub(r'【(?:治療期間・回数|期間・回数|治療期間|期間|回数)】[\s\S]*?(?=【|$)', '', remaining)
    remaining = re.sub(r'【費用】[\s\S]*?(?=【|$)', '', remaining)
    remaining = re.sub(r'【リスク[・／]?副作用】[\s\S]*?(?=【|$)', '', remaining)
    remaining = remaining.strip()
    
    # 何も抽出できなければcaptionをそのまま残す
    if not any([treatment_content, treatment_duration, treatment_cost_text, risks]):
        remaining = caption
    
    return {
        'treatment_content': treatment_content,
        'treatment_duration': treatment_duration,
        'treatment_cost_text': treatment_cost_text,
        'risks': risks,
        'remaining': remaining if remaining else None
    }


def download_image(url, temp_dir):
    """画像をダウンロードして一時ファイルに保存"""
    if not url or not url.startswith('http'):
        return None
    
    try:
        # URLエンコード処理（日本語ファイル名対応）
        parsed = urllib.parse.urlparse(url)
        encoded_path = urllib.parse.quote(parsed.path, safe='/')
        encoded_url = f"{parsed.scheme}://{parsed.netloc}{encoded_path}"
        
        # ファイル名生成
        ext = Path(parsed.path).suffix or '.jpg'
        if ext not in ['.jpg', '.jpeg', '.png', '.gif', '.webp']:
            ext = '.jpg'
        
        # URLからハッシュでユニークなファイル名を生成
        hash_name = hashlib.md5(url.encode()).hexdigest()[:16]
        filename = f"{hash_name}{ext}"
        filepath = temp_dir / filename
        
        if filepath.exists():
            return filepath
        
        print(f"  Downloading: {url[:80]}...")
        
        req = urllib.request.Request(
            encoded_url,
            headers={'User-Agent': 'Mozilla/5.0 (compatible; LedianBot/1.0)'}
        )
        with urllib.request.urlopen(req, timeout=30) as response:
            with open(filepath, 'wb') as f:
                f.write(response.read())
        
        return filepath
    except Exception as e:
        print(f"  Download failed: {e}", file=sys.stderr)
        return None


def upload_to_r2(filepath, key):
    """R2にファイルをアップロード"""
    try:
        cmd = [
            "npx", "wrangler", "r2", "object", "put",
            f"ledian-clinic-assets/{key}",
            "--file", str(filepath),
            "--remote"
        ]
        
        result = subprocess.run(
            cmd,
            cwd=Path(__file__).parent.parent / "apps" / "internal-site",
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            print(f"  R2 upload failed: {result.stderr}", file=sys.stderr)
            return None
        
        # R2のPublic URLを返す（Cloudflare R2 Public Access）
        # 実際のドメインは設定に応じて変更
        return f"https://pub-ledian-assets.r2.dev/{key}"
    except Exception as e:
        print(f"  R2 upload error: {e}", file=sys.stderr)
        return None


def escape_sql(s):
    """SQL用にエスケープ"""
    if s is None:
        return "NULL"
    escaped = s.replace("'", "''")
    return f"'{escaped}'"


def main():
    parser = argparse.ArgumentParser(description='症例写真データの正規化')
    parser.add_argument('--dry-run', action='store_true', help='実行せずに確認のみ')
    parser.add_argument('--skip-images', action='store_true', help='画像のR2移行をスキップ')
    parser.add_argument('--limit', type=int, default=0, help='処理件数を制限')
    args = parser.parse_args()
    
    print("=" * 60)
    print("症例写真データ正規化スクリプト")
    print("=" * 60)
    
    # 全データ取得
    query = "SELECT id, before_image_url, after_image_url, caption, treatment_content, treatment_duration, treatment_cost_text, risks FROM treatment_before_afters"
    if args.limit > 0:
        query += f" LIMIT {args.limit}"
    
    result = run_d1_query(query)
    
    if not result or 'results' not in result:
        print("データの取得に失敗しました")
        return 1
    
    rows = result['results']
    print(f"\n取得件数: {len(rows)}件")
    
    # 一時ディレクトリ
    temp_dir = Path(__file__).parent / ".temp_images"
    if not args.skip_images and not args.dry_run:
        temp_dir.mkdir(exist_ok=True)
    
    updates = []
    
    for i, row in enumerate(rows):
        print(f"\n[{i+1}/{len(rows)}] ID: {row['id']}")
        
        update_fields = {}
        
        # 1. captionをパース（個別フィールドが空の場合のみ）
        if not row.get('treatment_content') and not row.get('treatment_duration') and not row.get('treatment_cost_text') and not row.get('risks'):
            if row.get('caption') and '【' in row['caption']:
                parsed = parse_caption(row['caption'])
                
                if parsed['treatment_content']:
                    update_fields['treatment_content'] = parsed['treatment_content']
                    print(f"  → treatment_content: {parsed['treatment_content'][:50]}...")
                
                if parsed['treatment_duration']:
                    update_fields['treatment_duration'] = parsed['treatment_duration']
                    print(f"  → treatment_duration: {parsed['treatment_duration'][:50]}...")
                
                if parsed['treatment_cost_text']:
                    update_fields['treatment_cost_text'] = parsed['treatment_cost_text']
                    print(f"  → treatment_cost_text: {parsed['treatment_cost_text'][:50]}...")
                
                if parsed['risks']:
                    update_fields['risks'] = parsed['risks']
                    print(f"  → risks: {parsed['risks'][:50]}...")
                
                if parsed['remaining'] and parsed['remaining'] != row['caption']:
                    update_fields['caption'] = parsed['remaining']
                    print(f"  → caption (残り): {parsed['remaining'][:50]}...")
        else:
            print("  個別フィールド既存のためスキップ")
        
        # 2. 画像をR2にアップロード（スキップオプションがない場合）
        # ※ R2のPublic URLが設定されていない場合は外部URLのままにする
        # 今回は画像移行は別途実装が必要（R2 Public Accessの設定等）
        
        if update_fields:
            updates.append({
                'id': row['id'],
                'fields': update_fields
            })
    
    print(f"\n\n更新対象: {len(updates)}件")
    
    if args.dry_run:
        print("\n[DRY RUN] 実際の更新は行いません")
        for u in updates[:5]:
            print(f"  {u['id']}: {list(u['fields'].keys())}")
        if len(updates) > 5:
            print(f"  ... 他 {len(updates) - 5}件")
        return 0
    
    # 実際の更新
    print("\nデータベースを更新中...")
    success_count = 0
    
    for u in updates:
        set_clauses = []
        for field, value in u['fields'].items():
            set_clauses.append(f"{field} = {escape_sql(value)}")
        
        if not set_clauses:
            continue
        
        update_query = f"UPDATE treatment_before_afters SET {', '.join(set_clauses)}, updated_at = datetime('now') WHERE id = '{u['id']}'"
        
        result = run_d1_query(update_query)
        if result:
            success_count += 1
            print(f"  ✓ {u['id']}")
        else:
            print(f"  ✗ {u['id']}")
    
    print(f"\n完了: {success_count}/{len(updates)}件 更新")
    
    # 一時ディレクトリ削除
    if temp_dir.exists():
        import shutil
        shutil.rmtree(temp_dir)
    
    return 0


if __name__ == '__main__':
    sys.exit(main())

