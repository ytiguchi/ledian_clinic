#!/bin/bash
# データベースをリセットしてマイグレーションとシードを実行

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "🗑️  ステップ1/6: ローカルデータベースをリセット..."
echo "=========================================="
rm -rf .wrangler/state/v3/d1
echo "✅ リセット完了"

echo ""
echo "=========================================="
echo "📊 ステップ2/6: マイグレーションを実行..."
echo "=========================================="
source ~/.nvm/nvm.sh && nvm use 20
./database/d1/migrate-local.sh internal
echo "✅ マイグレーション完了"

echo ""
echo "=========================================="
echo "🧹 ステップ3/7: 既存データをクリア..."
echo "=========================================="
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --command "DELETE FROM treatment_plans; DELETE FROM treatments; DELETE FROM subcategories; DELETE FROM categories;" \
  2>&1 | tail -n 3
echo "✅ クリア完了"

echo ""
echo "=========================================="
echo "📥 ステップ4/7: カテゴリを投入..."
echo "=========================================="
grep "^INSERT.*categories" database/seed_d1_ignore.sql > /tmp/categories.sql
echo "  カテゴリSQLファイル作成: $(wc -l < /tmp/categories.sql)行"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/categories.sql 2>&1 | tail -n 3
echo "✅ カテゴリ投入完了"

echo ""
echo "=========================================="
echo "📥 ステップ5/7: サブカテゴリを投入..."
echo "=========================================="
grep "^INSERT.*subcategories" database/seed_d1_ignore.sql > /tmp/subcategories.sql
echo "  サブカテゴリSQLファイル作成: $(wc -l < /tmp/subcategories.sql)行"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/subcategories.sql 2>&1 | tail -n 3
echo "✅ サブカテゴリ投入完了"

echo ""
echo "=========================================="
echo "📥 ステップ6/7: 施術を投入..."
echo "=========================================="
grep "^INSERT.*treatments" database/seed_d1_ignore.sql > /tmp/treatments.sql
echo "  施術SQLファイル作成: $(wc -l < /tmp/treatments.sql)行"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/treatments.sql 2>&1 | tail -n 3
echo "✅ 施術投入完了"

echo ""
echo "=========================================="
echo "📥 ステップ7/7: プランを投入..."
echo "=========================================="
grep "^INSERT.*treatment_plans" database/seed_d1_ignore.sql > /tmp/plans.sql
echo "  プランSQLファイル作成: $(wc -l < /tmp/plans.sql)行"
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file /tmp/plans.sql 2>&1 | tail -n 3
echo "✅ プラン投入完了"

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
  2>&1 | grep -A 10 "results"

echo ""
echo "✅ すべて完了！"

