#!/usr/bin/env python3
"""
外部画像をR2に移行するスクリプト

使用方法:
  python scripts/migrate_images_to_r2.py --dry-run  # 確認のみ
  python scripts/migrate_images_to_r2.py            # 実行
"""

import json
import subprocess
import sys
import argparse
import urllib.request
import urllib.parse
import os
import hashlib
from pathlib import Path


def run_d1_query(query, remote=True):
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
        output = result.stdout.strip()
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
        return {}


def download_image(url, temp_dir):
    """画像をダウンロードして一時ファイルに保存"""
    if not url or not url.startswith('http'):
        return None, None
    
    try:
        # URLエンコード処理（日本語ファイル名対応）
        parsed = urllib.parse.urlparse(url)
        encoded_path = urllib.parse.quote(parsed.path, safe='/')
        encoded_url = f"{parsed.scheme}://{parsed.netloc}{encoded_path}"
        
        # ファイル名生成
        ext = Path(parsed.path).suffix.lower() or '.jpg'
        if ext not in ['.jpg', '.jpeg', '.png', '.gif', '.webp']:
            ext = '.jpg'
        
        # URLからハッシュでユニークなファイル名を生成
        hash_name = hashlib.md5(url.encode()).hexdigest()
        filename = f"{hash_name}{ext}"
        filepath = temp_dir / filename
        
        if filepath.exists():
            return filepath, filename
        
        print(f"    Downloading: {url[:60]}...")
        
        req = urllib.request.Request(
            encoded_url,
            headers={'User-Agent': 'Mozilla/5.0 (compatible; LedianBot/1.0)'}
        )
        with urllib.request.urlopen(req, timeout=30) as response:
            with open(filepath, 'wb') as f:
                f.write(response.read())
        
        return filepath, filename
    except Exception as e:
        print(f"    Download failed: {e}", file=sys.stderr)
        return None, None


def upload_to_r2(filepath, key, bucket_name="ledian-clinic-assets"):
    """R2にファイルをアップロード"""
    try:
        cmd = [
            "npx", "wrangler", "r2", "object", "put",
            f"{bucket_name}/{key}",
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
            print(f"    R2 upload failed: {result.stderr}", file=sys.stderr)
            return None
        
        print(f"    Uploaded: {key}")
        return key
    except Exception as e:
        print(f"    R2 upload error: {e}", file=sys.stderr)
        return None


def escape_sql(s):
    """SQL用にエスケープ"""
    if s is None:
        return "NULL"
    escaped = s.replace("'", "''")
    return f"'{escaped}'"


def main():
    parser = argparse.ArgumentParser(description='外部画像をR2に移行')
    parser.add_argument('--dry-run', action='store_true', help='実行せずに確認のみ')
    parser.add_argument('--limit', type=int, default=0, help='処理件数を制限')
    parser.add_argument('--r2-base-url', type=str, 
                        default='https://pub-ledian.r2.dev',
                        help='R2のPublic Base URL')
    args = parser.parse_args()
    
    print("=" * 60)
    print("外部画像 → R2 移行スクリプト")
    print("=" * 60)
    print(f"R2 Base URL: {args.r2_base_url}")
    
    # 全データ取得
    query = "SELECT id, before_image_url, after_image_url FROM treatment_before_afters"
    if args.limit > 0:
        query += f" LIMIT {args.limit}"
    
    result = run_d1_query(query)
    
    if not result or 'results' not in result:
        print("データの取得に失敗しました")
        return 1
    
    rows = result['results']
    print(f"\n取得件数: {len(rows)}件")
    
    # 外部URLをカウント
    external_count = 0
    for row in rows:
        if row.get('before_image_url') and 'ledianclinic.jp' in row['before_image_url']:
            external_count += 1
        if row.get('after_image_url') and 'ledianclinic.jp' in row['after_image_url']:
            external_count += 1
    
    print(f"外部URL件数: {external_count}件")
    
    if args.dry_run:
        print("\n[DRY RUN] 実際のアップロードは行いません")
        for row in rows[:5]:
            if row.get('after_image_url') and 'ledianclinic.jp' in row['after_image_url']:
                print(f"  {row['id']}: {row['after_image_url'][:60]}...")
        if len(rows) > 5:
            print(f"  ... 他 {len(rows) - 5}件")
        return 0
    
    # 一時ディレクトリ
    temp_dir = Path(__file__).parent / ".temp_images"
    temp_dir.mkdir(exist_ok=True)
    
    updates = []
    
    for i, row in enumerate(rows):
        print(f"\n[{i+1}/{len(rows)}] ID: {row['id']}")
        
        update_fields = {}
        
        # before_image_urlの処理
        before_url = row.get('before_image_url', '')
        if before_url and 'ledianclinic.jp' in before_url:
            filepath, filename = download_image(before_url, temp_dir)
            if filepath and filename:
                key = f"before-afters/before/{filename}"
                uploaded_key = upload_to_r2(filepath, key)
                if uploaded_key:
                    new_url = f"{args.r2_base_url}/{uploaded_key}"
                    update_fields['before_image_url'] = new_url
        
        # after_image_urlの処理
        after_url = row.get('after_image_url', '')
        if after_url and 'ledianclinic.jp' in after_url:
            filepath, filename = download_image(after_url, temp_dir)
            if filepath and filename:
                key = f"before-afters/after/{filename}"
                uploaded_key = upload_to_r2(filepath, key)
                if uploaded_key:
                    new_url = f"{args.r2_base_url}/{uploaded_key}"
                    update_fields['after_image_url'] = new_url
        
        if update_fields:
            updates.append({
                'id': row['id'],
                'fields': update_fields
            })
    
    print(f"\n\n更新対象: {len(updates)}件")
    
    # 実際の更新
    if updates:
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
    
    # 一時ディレクトリは残しておく（再実行時のキャッシュ）
    print(f"\n一時ファイル: {temp_dir}")
    
    return 0


if __name__ == '__main__':
    sys.exit(main())

