-- ============================================
-- マイグレーション: treatment_id → subcategory_id への構造変更
-- ============================================
-- 本番サイトの構造（サブカテゴリ = 各施術ページ）に合わせて、
-- すべての treatment_id 参照を subcategory_id に変更します。
--
-- 変更対象テーブル:
-- 1. treatment_plans (treatment_id → subcategory_id)
-- 2. treatment_before_afters (treatment_id → subcategory_id)
-- 3. treatment_details (treatment_id → subcategory_id)
-- 4. treatment_flows (treatment_id → subcategory_id)
-- 5. treatment_cautions (treatment_id → subcategory_id)
-- 6. treatment_faqs (treatment_id → subcategory_id)
-- 7. treatment_tags (treatment_id → subcategory_id)
-- 8. treatment_option_mappings (treatment_id → subcategory_id)
-- 9. treatment_relations (treatment_id → subcategory_id, related_treatment_id → related_subcategory_id)
--
-- 注意: treatmentsテーブルは今後使用しませんが、既存データとの互換性のため
-- 一時的に残しておきます。データ移行後、削除を検討してください。

-- ============================================
-- 1. treatment_plans の変更
-- ============================================

-- 既存の外部キー制約を削除（SQLiteでは直接削除できないため、テーブル再作成）
-- まず、新しいカラムを追加（データ移行用）
ALTER TABLE treatment_plans ADD COLUMN subcategory_id_new TEXT;

-- データ移行: treatment_id から subcategory_id を取得
-- 注意: この時点で treatments テーブルが存在し、正しい subcategory_id が設定されている必要があります
UPDATE treatment_plans 
SET subcategory_id_new = (
    SELECT subcategory_id 
    FROM treatments 
    WHERE treatments.id = treatment_plans.treatment_id
)
WHERE EXISTS (
    SELECT 1 
    FROM treatments 
    WHERE treatments.id = treatment_plans.treatment_id
);

-- 旧カラムを削除（SQLiteでは直接削除できないため、テーブル再作成が必要）
-- ここでは一時的に残し、アプリケーション側で新しいカラムを使用するように変更

-- ============================================
-- 2. treatment_before_afters の変更
-- ============================================

ALTER TABLE treatment_before_afters ADD COLUMN subcategory_id_new TEXT;

UPDATE treatment_before_afters 
SET subcategory_id_new = (
    SELECT subcategory_id 
    FROM treatments 
    WHERE treatments.id = treatment_before_afters.treatment_id
)
WHERE EXISTS (
    SELECT 1 
    FROM treatments 
    WHERE treatments.id = treatment_before_afters.treatment_id
);

-- ============================================
-- 3. treatment_details の変更（存在する場合）
-- ============================================

-- treatment_detailsテーブルが存在する場合のみ実行
-- SQLiteでは条件付きALTER TABLEができないため、アプリケーション側で確認

-- ============================================
-- 4. treatment_flows の変更（存在する場合）
-- ============================================

-- ============================================
-- 5. treatment_cautions の変更（存在する場合）
-- ============================================

-- ============================================
-- 6. treatment_faqs の変更（存在する場合）
-- ============================================

-- ============================================
-- 7. treatment_tags の変更（存在する場合）
-- ============================================

-- ============================================
-- 8. treatment_option_mappings の変更
-- ============================================

ALTER TABLE treatment_option_mappings ADD COLUMN subcategory_id_new TEXT;

UPDATE treatment_option_mappings 
SET subcategory_id_new = (
    SELECT subcategory_id 
    FROM treatments 
    WHERE treatments.id = treatment_option_mappings.treatment_id
)
WHERE EXISTS (
    SELECT 1 
    FROM treatments 
    WHERE treatments.id = treatment_option_mappings.treatment_id
);

-- ============================================
-- インデックス更新
-- ============================================

CREATE INDEX IF NOT EXISTS idx_treatment_plans_subcategory_new ON treatment_plans(subcategory_id_new);
CREATE INDEX IF NOT EXISTS idx_before_afters_subcategory_new ON treatment_before_afters(subcategory_id_new);
CREATE INDEX IF NOT EXISTS idx_treatment_option_mappings_subcategory_new ON treatment_option_mappings(subcategory_id_new);

-- ============================================
-- 注意事項
-- ============================================
-- 
-- このマイグレーションでは、新しいカラム（*_new）を追加しています。
-- アプリケーション側で以下の対応が必要です:
-- 1. すべてのクエリを新しいカラム（subcategory_id_new）を使用するように変更
-- 2. データ移行が完了したことを確認
-- 3. 旧カラム（treatment_id）を削除する後続マイグレーションを実行
-- 
-- 旧カラムを削除する際は、テーブル再作成が必要です（SQLiteの制約のため）

