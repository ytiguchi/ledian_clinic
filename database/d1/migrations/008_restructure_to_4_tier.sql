-- ============================================
-- マイグレーション: 4階層構造への再構築
-- ============================================
-- 現在の構造: Category → Subcategory（実際の施術） → Treatment Plan
-- 新しい構造: Category → Subcategory（治療法グループ） → Treatment（個別施術） → Treatment Plan
--
-- 手順:
-- 1. 既存のsubcategories（実際の施術）をtreatmentsに移動
-- 2. 新しいsubcategoriesテーブルを作成（治療法グループ用）
-- 3. treatmentsのsubcategory_idを新しいsubcategoriesに更新
-- 4. treatment_plansをtreatment_idベースに変更

PRAGMA foreign_keys=off;

-- ============================================
-- 1. 既存のsubcategories（実際の施術）をtreatmentsに移動
-- ============================================

-- 既存のtreatmentsテーブルをバックアップ（存在する場合）
CREATE TABLE IF NOT EXISTS treatments_backup AS 
SELECT * FROM treatments WHERE EXISTS (SELECT 1 FROM sqlite_master WHERE type='table' AND name='treatments');

-- 既存のsubcategoriesをtreatmentsに変換
-- 注意: 既存のtreatmentsがある場合は、IDが重複しないように新しいIDを生成
INSERT OR IGNORE INTO treatments (
    id, subcategory_id, name, slug, description, sort_order, is_active, created_at, updated_at
)
SELECT 
    id,  -- 既存のsubcategoryのIDをそのまま使用
    id AS subcategory_id,  -- 旧subcategoriesを一時的に参照（後で更新）
    name,
    slug,
    NULL AS description,
    sort_order,
    is_active,
    created_at,
    updated_at
FROM subcategories
WHERE NOT EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = subcategories.id
);

-- ============================================
-- 2. 新しいsubcategoriesテーブル構造を作成
-- ============================================

-- 既存のsubcategoriesテーブルをリネーム
ALTER TABLE subcategories RENAME TO subcategories_old;

-- 新しいsubcategoriesテーブルを作成（治療法グループ用）
CREATE TABLE IF NOT EXISTS subcategories (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    description TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(category_id, slug)
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_subcategories_category ON subcategories(category_id);

-- ============================================
-- 3. カテゴリーごとに治療法グループを作成
-- ============================================

-- 各カテゴリーに対して、1つの治療法グループを作成
-- カテゴリー名をそのまま治療法グループ名として使用
INSERT INTO subcategories (id, category_id, name, slug, description, sort_order, is_active)
SELECT 
    lower(hex(randomblob(16))) AS id,
    c.id AS category_id,
    c.name || '治療' AS name,
    c.slug || '-treatment' AS slug,
    c.name || 'の治療法' AS description,
    c.sort_order AS sort_order,
    1 AS is_active
FROM categories c
WHERE NOT EXISTS (
    SELECT 1 FROM subcategories WHERE subcategories.category_id = c.id
);

-- subcategories_old に新しいsubcategoriesのIDを同期（FK整合のため）
INSERT INTO subcategories_old (id, category_id, name, slug, sort_order, is_active, created_at, updated_at)
SELECT
    sc.id,
    sc.category_id,
    sc.name,
    sc.slug,
    sc.sort_order,
    sc.is_active,
    sc.created_at,
    sc.updated_at
FROM subcategories sc
WHERE NOT EXISTS (
    SELECT 1 FROM subcategories_old WHERE subcategories_old.id = sc.id
);

-- ============================================
-- 4. treatmentsテーブルのsubcategory_idを更新
-- ============================================

-- 各カテゴリーの最初のsubcategory（治療法グループ）を取得して、treatmentsのsubcategory_idを更新
UPDATE treatments
SET subcategory_id = (
    SELECT sc.id 
    FROM subcategories sc
    JOIN subcategories_old sc_old ON sc.category_id = (
        SELECT category_id FROM subcategories_old WHERE id = treatments.id
    )
    WHERE sc.category_id = sc_old.category_id
    LIMIT 1
)
WHERE EXISTS (
    SELECT 1 FROM subcategories_old WHERE subcategories_old.id = treatments.id
);

-- ============================================
-- 5. treatment_plansをtreatment_idベースに変更
-- ============================================

-- 既存のビューを削除（テーブル削除前に）
DROP VIEW IF EXISTS v_price_list;
DROP VIEW IF EXISTS v_treatments_full;

-- 既存のtreatment_plansがsubcategory_idを参照している場合は、treatment_idに変更
-- SQLiteでは直接DROP COLUMNできないため、テーブル再作成が必要

-- 新しいtreatment_plansテーブルを作成
CREATE TABLE IF NOT EXISTS treatment_plans_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    plan_name VARCHAR(100) NOT NULL,
    plan_type TEXT NOT NULL DEFAULT 'single' CHECK (plan_type IN ('single','course','trial','monitor','campaign')),
    sessions INTEGER,
    quantity VARCHAR(50),
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    price_per_session INTEGER,
    price_per_session_taxed INTEGER,
    campaign_price INTEGER,
    campaign_price_taxed INTEGER,
    cost_rate REAL,
    campaign_cost_rate REAL,
    supply_cost INTEGER,
    staff_cost INTEGER,
    total_cost INTEGER,
    old_price INTEGER,
    staff_discount_rate INTEGER,
    notes TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- データ移行: subcategory_idから対応するtreatment_idを取得
-- 注意: 1つのsubcategory（旧）に複数のtreatmentがある場合は、最初のものを使用
INSERT INTO treatment_plans_new (
    id, treatment_id, plan_name, plan_type, sessions, quantity,
    price, price_taxed, price_per_session, price_per_session_taxed,
    campaign_price, campaign_price_taxed, cost_rate, campaign_cost_rate,
    supply_cost, staff_cost, total_cost, old_price, staff_discount_rate,
    notes, sort_order, is_active, created_at, updated_at
)
SELECT 
    tp.id,
    -- subcategory_id（旧）から対応するtreatment_idを取得
    (SELECT t.id FROM treatments t 
     JOIN subcategories_old sc_old ON t.id = sc_old.id
     WHERE sc_old.id = tp.subcategory_id
     LIMIT 1) AS treatment_id,
    tp.plan_name,
    tp.plan_type,
    tp.sessions,
    tp.quantity,
    tp.price,
    tp.price_taxed,
    tp.price_per_session,
    tp.price_per_session_taxed,
    tp.campaign_price,
    tp.campaign_price_taxed,
    tp.cost_rate,
    tp.campaign_cost_rate,
    tp.supply_cost,
    tp.staff_cost,
    tp.total_cost,
    tp.old_price,
    tp.staff_discount_rate,
    tp.notes,
    tp.sort_order,
    tp.is_active,
    tp.created_at,
    tp.updated_at
FROM treatment_plans tp
WHERE tp.subcategory_id IS NOT NULL;

-- 旧テーブルを削除して新テーブルにリネーム
DROP TABLE IF EXISTS treatment_plans;
ALTER TABLE treatment_plans_new RENAME TO treatment_plans;

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_treatment_plans_treatment ON treatment_plans(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_type ON treatment_plans(plan_type);

-- ============================================
-- 6. ビューを再作成（テーブルリネーム後に実行）
-- ============================================
CREATE VIEW IF NOT EXISTS v_treatments_full AS
SELECT 
    t.id,
    t.name AS treatment_name,
    t.slug AS treatment_slug,
    t.description,
    sc.id AS subcategory_id,
    sc.name AS subcategory_name,
    c.id AS category_id,
    c.name AS category_name,
    t.is_active,
    t.sort_order
FROM treatments t
JOIN subcategories sc ON t.subcategory_id = sc.id
JOIN categories c ON sc.category_id = c.id;

DROP VIEW IF EXISTS v_price_list;
CREATE VIEW IF NOT EXISTS v_price_list AS
SELECT 
    c.name AS category_name,
    sc.name AS subcategory_name,
    t.name AS treatment_name,
    tp.plan_name,
    tp.plan_type,
    tp.sessions,
    tp.quantity,
    tp.price,
    tp.price_taxed,
    tp.price_per_session,
    tp.campaign_price,
    tp.campaign_price_taxed,
    tp.cost_rate,
    tp.notes
FROM treatment_plans tp
JOIN treatments t ON tp.treatment_id = t.id
JOIN subcategories sc ON t.subcategory_id = sc.id
JOIN categories c ON sc.category_id = c.id
WHERE tp.is_active = 1;

-- ============================================
-- 7. 古いテーブルを削除（オプション、データ保持が必要な場合はコメントアウト）
-- ============================================

-- DROP TABLE IF EXISTS subcategories_old;
-- DROP TABLE IF EXISTS treatments_backup;

PRAGMA foreign_keys=on;
