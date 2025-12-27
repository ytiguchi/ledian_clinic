#!/bin/bash
# シードデータを正しい順序で投入するスクリプト

set -e

cd "$(dirname "$0")/.."

WRANGLER="npx wrangler@4.56.0"
DB_NAME="ledian-internal-prod"
CONFIG="wrangler.internal.toml"
SEED_SQL="database/d1/seed-all.sql"
TMP_DIR="tmp/seed"

mkdir -p "$TMP_DIR"

run_seed_step() {
  local step_no="$1"
  local label="$2"
  local table_name="$3"
  local tmp_file="$4"

  echo ""
  echo "=========================================="
  echo ">> ステップ${step_no}: ${label}を投入..."
  echo "=========================================="
  grep -E "^INSERT INTO ${table_name} \\(" "$SEED_SQL" > "$tmp_file"
  echo "  $(wc -l < "$tmp_file")件の${label}"
  $WRANGLER d1 execute "$DB_NAME" \
    --config "$CONFIG" \
    --local \
    --file "$tmp_file" \
    2>&1 | grep -E "(success|ERROR|commands executed)" || echo "OK ${label}投入完了"
}

echo "=========================================="
echo ">> ステップ1: 既存データをクリア..."
echo "=========================================="
$WRANGLER d1 execute "$DB_NAME" \
  --config "$CONFIG" \
  --local \
  --command "DELETE FROM treatment_plans; DELETE FROM treatments; DELETE FROM subcategories; DELETE FROM subcategories_old; DELETE FROM categories;" \
  2>&1 | grep -E "(success|ERROR)" || echo "OK クリア完了"

run_seed_step 2 "カテゴリ" "categories" "$TMP_DIR/categories.sql"
run_seed_step 3 "サブカテゴリ" "subcategories" "$TMP_DIR/subcategories.sql"

echo ""
echo "=========================================="
echo ">> ステップ3.5: subcategories_old を同期..."
echo "=========================================="
$WRANGLER d1 execute "$DB_NAME" \
  --config "$CONFIG" \
  --local \
  --command "INSERT INTO subcategories_old (id, category_id, name, slug, sort_order, is_active, created_at, updated_at) SELECT id, category_id, name, slug, sort_order, is_active, created_at, updated_at FROM subcategories;" \
  2>&1 | grep -E "(success|ERROR|commands executed)" || echo "OK subcategories_old 同期完了"
run_seed_step 4 "施術" "treatments" "$TMP_DIR/treatments.sql"
run_seed_step 5 "プラン" "treatment_plans" "$TMP_DIR/plans.sql"

echo ""
echo "=========================================="
echo ">> 最終確認..."
echo "=========================================="
$WRANGLER d1 execute "$DB_NAME" \
  --config "$CONFIG" \
  --local \
  --command "SELECT 
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM subcategories) as subcategories,
    (SELECT COUNT(*) FROM treatments) as treatments,
    (SELECT COUNT(*) FROM treatment_plans) as plans;" \
  2>&1 | grep -A 10 "results" || echo "確認完了"

echo ""
echo "OK すべて完了！"
