#!/bin/bash
# シードデータを一括投入するスクリプト

set -e

cd "$(dirname "$0")/.."

echo "📊 シードデータを投入します..."

# データベースをクリア
echo "1. 既存データをクリア..."
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --command "DELETE FROM treatment_plans; DELETE FROM treatments; DELETE FROM subcategories; DELETE FROM categories;" \
  > /dev/null 2>&1

# カテゴリ投入
echo "2. カテゴリを投入中..."
grep "^INSERT.*categories" database/seed_d1_ignore.sql | \
  npx wrangler@4.56.0 d1 execute ledian-internal-prod \
    --config wrangler.internal.toml \
    --local \
    --stdin \
  > /dev/null 2>&1

# サブカテゴリ投入
echo "3. サブカテゴリを投入中..."
grep "^INSERT.*subcategories" database/seed_d1_ignore.sql | \
  npx wrangler@4.56.0 d1 execute ledian-internal-prod \
    --config wrangler.internal.toml \
    --local \
    --stdin \
  > /dev/null 2>&1

# 施術投入
echo "4. 施術を投入中..."
grep "^INSERT.*treatments" database/seed_d1_ignore.sql | \
  npx wrangler@4.56.0 d1 execute ledian-internal-prod \
    --config wrangler.internal.toml \
    --local \
    --stdin \
  > /dev/null 2>&1

# プラン投入
echo "5. プランを投入中..."
grep "^INSERT.*treatment_plans" database/seed_d1_ignore.sql | \
  npx wrangler@4.56.0 d1 execute ledian-internal-prod \
    --config wrangler.internal.toml \
    --local \
    --stdin \
  > /dev/null 2>&1

echo "✅ 完了！"

# 確認
echo ""
echo "📊 投入結果:"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --command "SELECT 
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM subcategories) as subcategories,
    (SELECT COUNT(*) FROM treatments) as treatments,
    (SELECT COUNT(*) FROM treatment_plans) as plans;" \
  2>&1 | grep -A 5 "results"

