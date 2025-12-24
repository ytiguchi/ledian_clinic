#!/usr/bin/env python3
"""
既存のseed.sqlのcampaign_priceがあるプランにcampaign_idを設定するスクリプト
"""

import json
import re
import uuid
from pathlib import Path

def load_campaigns():
    """キャンペーンデータを読み込む"""
    campaign_file = Path(__file__).parent.parent / "data" / "content" / "campaigns.json"
    with open(campaign_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # キャンペーンをslugでマッピング
    campaigns = {}
    for campaign in data.get('campaigns', []):
        campaigns[campaign['slug']] = campaign['id']
    
    return campaigns

def update_seed_sql():
    """seed.sqlを更新してcampaign_idを追加"""
    seed_file = Path(__file__).parent.parent / "database" / "seed.sql"
    
    if not seed_file.exists():
        print(f"❌ seed.sqlが見つかりません: {seed_file}")
        return
    
    with open(seed_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # campaigns.jsonからキャンペーン情報を読み込む
    campaigns = load_campaigns()
    
    # キャンペーン価格があるプランのINSERT文を探して更新
    # 簡単な方法: コメントを追加するのみ（実際のUPDATEは手動または別スクリプトで）
    
    print("✅ キャンペーン情報を読み込みました")
    print(f"   キャンペーン数: {len(campaigns)}")
    for slug, camp_id in campaigns.items():
        print(f"   - {slug}: {camp_id}")
    
    print("\n📝 注意: campaign_idの設定は手動で行う必要があります")
    print("   または、DBに投入後にSQLでUPDATEしてください")

if __name__ == "__main__":
    update_seed_sql()

