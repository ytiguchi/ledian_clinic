#!/bin/bash
# レディアンクリニック DB セットアップスクリプト

set -e

DB_NAME="ledian_clinic"

echo "🚀 レディアンクリニック DB セットアップを開始します"
echo "=========================================="

# DBが存在するか確認
if ! psql -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    echo "📦 データベース '$DB_NAME' を作成中..."
    createdb "$DB_NAME"
    echo "✅ データベース作成完了"
else
    echo "ℹ️  データベース '$DB_NAME' は既に存在します"
fi

echo ""
echo "📋 スキーマを適用中..."
echo "1. 基本スキーマ (schema.sql)..."
psql -d "$DB_NAME" -f database/schema.sql

echo "2. コンテンツスキーマ (schema_content.sql)..."
psql -d "$DB_NAME" -f database/schema_content.sql

echo "3. キャンペーンIDマイグレーション..."
if psql -d "$DB_NAME" -c "\d treatment_plans" | grep -q "campaign_id"; then
    echo "   campaign_idカラムは既に存在します"
else
    psql -d "$DB_NAME" -f database/migration_add_campaign_id.sql
    echo "   ✅ campaign_idカラムを追加しました"
fi

echo ""
echo "📊 シードデータを投入中..."
psql -d "$DB_NAME" -f database/seed.sql

echo ""
echo "🎉 セットアップ完了！"
echo ""
echo "次のステップ:"
echo "1. campaignsテーブルにデータを投入"
echo "2. migration_set_campaign_ids.sql を実行してcampaign_idを設定"
echo ""
echo "確認コマンド:"
echo "  psql -d $DB_NAME -c \"SELECT COUNT(*) FROM categories;\""
echo "  psql -d $DB_NAME -c \"SELECT COUNT(*) FROM treatments;\""
echo "  psql -d $DB_NAME -c \"SELECT COUNT(*) FROM treatment_plans;\""

