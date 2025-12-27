#!/usr/bin/env python3
"""
サービスコンテンツ自動紐付けスクリプト
service_contents テーブルの subcategory_id を自動設定

Usage:
    python scripts/link_service_content.py

このスクリプトは以下のルールで紐付けを行います:
1. service_contents.name_ja と subcategories.name の完全一致
2. service_contents.name_ja と subcategories.device_name の完全一致
3. service_contents.name_ja が subcategories.name に含まれる (部分一致)
"""

import sys
import io

# Windows cp932 encoding fix
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

import json
import sqlite3
from pathlib import Path
from dataclasses import dataclass


@dataclass
class ServiceContent:
    id: str
    name_ja: str
    subcategory_id: str | None


@dataclass
class Subcategory:
    id: str
    name: str
    device_name: str | None
    category_name: str


def get_db_path() -> Path:
    """ローカルD1データベースのパスを取得"""
    base = Path("apps/internal-site/.wrangler/state/v3/d1")
    if not base.exists():
        raise FileNotFoundError(f"D1データベースが見つかりません: {base}")
    
    # miniflare-D1DatabaseObjectディレクトリを探す
    for item in base.iterdir():
        if item.is_dir() and item.name.startswith("miniflare"):
            for db_file in item.glob("*.sqlite"):
                return db_file
    
    raise FileNotFoundError("SQLiteファイルが見つかりません")


def load_data(conn: sqlite3.Connection) -> tuple[list[ServiceContent], list[Subcategory]]:
    """DBからデータを読み込み"""
    cursor = conn.cursor()
    
    # service_contents
    cursor.execute("SELECT id, name_ja, subcategory_id FROM service_contents")
    services = [ServiceContent(id=row[0], name_ja=row[1], subcategory_id=row[2]) for row in cursor.fetchall()]
    
    # subcategories with category name
    cursor.execute("""
        SELECT sc.id, sc.name, sc.device_name, c.name as category_name
        FROM subcategories sc
        JOIN categories c ON sc.category_id = c.id
    """)
    subcategories = [Subcategory(id=row[0], name=row[1], device_name=row[2], category_name=row[3]) for row in cursor.fetchall()]
    
    return services, subcategories


def find_match(service: ServiceContent, subcategories: list[Subcategory]) -> Subcategory | None:
    """サービスコンテンツに対応するサブカテゴリを検索"""
    name = service.name_ja.strip().lower()
    
    # 1. 完全一致 (name)
    for sub in subcategories:
        if sub.name.strip().lower() == name:
            return sub
    
    # 2. 完全一致 (device_name)
    for sub in subcategories:
        if sub.device_name and sub.device_name.strip().lower() == name:
            return sub
    
    # 3. 部分一致 (nameがsubcategory.nameに含まれる or 逆)
    for sub in subcategories:
        sub_name = sub.name.strip().lower()
        if name in sub_name or sub_name in name:
            return sub
    
    # 4. device_nameとの部分一致
    for sub in subcategories:
        if sub.device_name:
            device = sub.device_name.strip().lower()
            if name in device or device in name:
                return sub
    
    return None


def update_links(conn: sqlite3.Connection, links: list[tuple[str, str]]):
    """紐付けをDBに反映"""
    cursor = conn.cursor()
    for service_id, subcategory_id in links:
        cursor.execute(
            "UPDATE service_contents SET subcategory_id = ? WHERE id = ?",
            (subcategory_id, service_id)
        )
    conn.commit()


def generate_sql(links: list[tuple[str, str, str, str]], output_path: Path):
    """SQLファイルを生成"""
    lines = [
        "-- ============================================",
        "-- サービスコンテンツ自動紐付けSQL",
        "-- ============================================",
        "",
    ]
    
    for service_id, subcategory_id, service_name, subcategory_name in links:
        lines.append(f"-- {service_name} -> {subcategory_name}")
        lines.append(f"UPDATE service_contents SET subcategory_id = '{subcategory_id}' WHERE id = '{service_id}';")
        lines.append("")
    
    output_path.write_text("\n".join(lines), encoding="utf-8")


def main():
    print("=" * 50)
    print("サービスコンテンツ自動紐付け")
    print("=" * 50)
    
    try:
        db_path = get_db_path()
        print(f"[INFO] DB: {db_path}")
    except FileNotFoundError as e:
        print(f"[ERROR] {e}")
        return
    
    conn = sqlite3.connect(db_path)
    
    try:
        services, subcategories = load_data(conn)
        print(f"[INFO] サービスコンテンツ: {len(services)}件")
        print(f"[INFO] サブカテゴリ: {len(subcategories)}件")
        print()
        
        linked = []
        unlinked = []
        already_linked = []
        
        for service in services:
            if service.subcategory_id:
                already_linked.append(service)
                continue
            
            match = find_match(service, subcategories)
            if match:
                linked.append((service.id, match.id, service.name_ja, match.name))
            else:
                unlinked.append(service)
        
        # 結果表示
        print("[LINKED] 紐付け成功:")
        for service_id, sub_id, service_name, sub_name in linked:
            print(f"  {service_name} -> {sub_name}")
        
        print()
        print(f"[UNLINKED] 紐付け失敗 ({len(unlinked)}件):")
        for service in unlinked:
            print(f"  {service.name_ja}")
        
        if already_linked:
            print()
            print(f"[SKIP] 既に紐付け済み ({len(already_linked)}件)")
        
        # DBを更新
        if linked:
            print()
            print("[INFO] DBを更新中...")
            update_links(conn, [(s_id, sub_id) for s_id, sub_id, _, _ in linked])
            print(f"[OK] {len(linked)}件の紐付けを完了")
            
            # SQLファイルも生成
            sql_path = Path("database/d1/link_service_content.sql")
            generate_sql(linked, sql_path)
            print(f"[OK] SQL出力: {sql_path}")
        
        # サマリー
        print()
        print("=" * 50)
        print("サマリー")
        print("=" * 50)
        print(f"  紐付け成功: {len(linked)}件")
        print(f"  紐付け失敗: {len(unlinked)}件")
        print(f"  既に紐付け済み: {len(already_linked)}件")
        
    finally:
        conn.close()


if __name__ == "__main__":
    main()

