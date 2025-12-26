#!/bin/bash
# シードデータを正しい順序で投入するスクリプト

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "🧹 ステップ1: 既存データをクリア..."
echo "=========================================="
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --command "DELETE FROM treatment_plans; DELETE FROM treatments; DELETE FROM subcategories; DELETE FROM categories;" \
  2>&1 | grep -E "(success|ERROR)" || echo "✅ クリア完了"

echo ""
echo "=========================================="
echo "📥 ステップ2: カテゴリを投入..."
echo "=========================================="
grep "^INSERT.*categories" database/seed_d1_ignore.sql > /tmp/categories.sql
echo "  $(wc -l < /tmp/categories.sql)件のカテゴリ"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/categories.sql \
  2>&1 | grep -E "(success|ERROR|commands executed)" || echo "✅ カテゴリ投入完了"

echo ""
echo "=========================================="
echo "📥 ステップ3: サブカテゴリを投入..."
echo "=========================================="
grep "^INSERT.*subcategories" database/seed_d1_ignore.sql > /tmp/subcategories.sql
echo "  $(wc -l < /tmp/subcategories.sql)件のサブカテゴリ"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/subcategories.sql \
  2>&1 | grep -E "(success|ERROR|commands executed)" || echo "✅ サブカテゴリ投入完了"

echo ""
echo "=========================================="
echo "📥 ステップ4: 施術を投入..."
echo "=========================================="
grep "^INSERT.*treatments" database/seed_d1_ignore.sql > /tmp/treatments.sql
echo "  $(wc -l < /tmp/treatments.sql)件の施術"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/treatments.sql \
  2>&1 | grep -E "(success|ERROR|commands executed)" || echo "✅ 施術投入完了"

echo ""
echo "=========================================="
echo "📥 ステップ5: プランを投入..."
echo "=========================================="
grep "^INSERT.*treatment_plans" database/seed_d1_ignore.sql > /tmp/plans.sql
echo "  $(wc -l < /tmp/plans.sql)件のプラン"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/plans.sql \
  2>&1 | grep -E "(success|ERROR|commands executed)" || echo "✅ プラン投入完了"

echo ""
echo "=========================================="
echo "📊 最終確認..."
echo "=========================================="
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --command "SELECT 
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM subcategories) as subcategories,
    (SELECT COUNT(*) FROM treatments) as treatments,
    (SELECT COUNT(*) FROM treatment_plans) as plans;" \
  2>&1 | grep -A 10 "results" || echo "確認完了"

echo ""
echo "✅ すべて完了！"


