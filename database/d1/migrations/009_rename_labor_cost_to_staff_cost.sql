-- ============================================
-- マイグレーション: treatment_plans の labor_cost を staff_cost にリネーム
-- ============================================

-- ビューを削除（テーブル再作成前に必要）
DROP VIEW IF EXISTS v_price_list;
DROP VIEW IF EXISTS v_treatments_full;
DROP VIEW IF EXISTS v_campaign_prices;

-- テーブル再作成（labor_cost を staff_cost に変更）
CREATE TABLE IF NOT EXISTS treatment_plans_new (
    id TEXT PRIMARY KEY,
    treatment_id TEXT NOT NULL,
    plan_name TEXT NOT NULL,
    plan_type TEXT NOT NULL DEFAULT 'single',
    sessions INTEGER DEFAULT 1,
    quantity TEXT,
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    price_per_session INTEGER,
    price_per_session_taxed INTEGER,
    supply_cost INTEGER DEFAULT 0,
    staff_cost INTEGER DEFAULT 0,  -- labor_cost から staff_cost に変更
    total_cost INTEGER DEFAULT 0,
    cost_rate REAL,
    staff_discount_rate INTEGER,
    staff_price INTEGER,
    old_price INTEGER,
    old_price_taxed INTEGER,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    is_public INTEGER NOT NULL DEFAULT 1,
    is_recommended INTEGER NOT NULL DEFAULT 0,
    notes TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE
);

-- 既存データを移行（labor_cost を staff_cost に変更）
INSERT INTO treatment_plans_new (
    id, treatment_id, plan_name, plan_type, sessions, quantity,
    price, price_taxed, price_per_session, price_per_session_taxed,
    supply_cost, staff_cost, total_cost, cost_rate,
    staff_discount_rate, staff_price, old_price, old_price_taxed,
    sort_order, is_active, is_public, is_recommended, notes,
    created_at, updated_at
)
SELECT 
    id, treatment_id, plan_name, plan_type, sessions, quantity,
    price, price_taxed, price_per_session, price_per_session_taxed,
    supply_cost, labor_cost AS staff_cost, total_cost, cost_rate,
    staff_discount_rate, staff_price, old_price, old_price_taxed,
    sort_order, is_active, is_public, is_recommended, notes,
    created_at, updated_at
FROM treatment_plans;

-- 旧テーブルを削除
DROP TABLE IF EXISTS treatment_plans;

-- 新テーブルをリネーム
ALTER TABLE treatment_plans_new RENAME TO treatment_plans;

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_treatment_plans_treatment ON treatment_plans(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_type ON treatment_plans(plan_type);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_active ON treatment_plans(is_active);

-- ビューを再作成（treatment_id ベースのまま、subcategory_id への移行は別マイグレーションで対応）
-- 注意: このビューは treatment_id を使用していますが、将来的に subcategory_id に移行する予定です
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
    tp.price_per_session_taxed,
    tp.cost_rate,
    tp.notes
FROM treatment_plans tp
JOIN treatments t ON tp.treatment_id = t.id
JOIN subcategories sc ON t.subcategory_id = sc.id
JOIN categories c ON sc.category_id = c.id
WHERE tp.is_active = 1;

