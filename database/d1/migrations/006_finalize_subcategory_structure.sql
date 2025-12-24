-- ============================================
-- マイグレーション: 最終的なサブカテゴリベース構造への移行完了
-- ============================================
-- 前回のマイグレーション（005）で追加した *_new カラムを正式なカラムに置き換え、
-- 旧 treatment_id カラムを削除します。
--
-- 注意: SQLiteではカラムの直接削除ができないため、テーブル再作成が必要です。
-- このマイグレーションは既存データの移行が完了していることを前提とします。

-- ============================================
-- 1. treatment_plans テーブルの再構築
-- ============================================

-- 一時テーブルにデータをコピー
CREATE TABLE IF NOT EXISTS treatment_plans_temp AS
SELECT 
    id,
    COALESCE(subcategory_id_new, treatment_id) AS subcategory_id,
    plan_name,
    plan_type,
    sessions,
    quantity,
    price,
    price_taxed,
    price_per_session,
    price_per_session_taxed,
    campaign_price,
    campaign_price_taxed,
    cost_rate,
    campaign_cost_rate,
    supply_cost,
    staff_cost,
    total_cost,
    old_price,
    staff_discount_rate,
    notes,
    sort_order,
    is_active,
    created_at,
    updated_at
FROM treatment_plans;

-- 旧テーブルを削除
DROP TABLE IF EXISTS treatment_plans;

-- 新しいテーブルを作成（subcategory_id を直接使用）
CREATE TABLE treatment_plans (
    id TEXT PRIMARY KEY,
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
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

-- データをコピー
INSERT INTO treatment_plans SELECT * FROM treatment_plans_temp;

-- 一時テーブルを削除
DROP TABLE IF EXISTS treatment_plans_temp;

-- インデックス再作成
CREATE INDEX IF NOT EXISTS idx_treatment_plans_subcategory ON treatment_plans(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_type ON treatment_plans(plan_type);

-- ============================================
-- 2. treatment_before_afters テーブルの再構築
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_before_afters_temp AS
SELECT 
    id,
    COALESCE(subcategory_id_new, treatment_id) AS subcategory_id,
    before_image_url,
    after_image_url,
    caption,
    patient_age,
    patient_gender,
    treatment_count,
    treatment_period,
    is_published,
    sort_order,
    created_at
FROM treatment_before_afters;

DROP TABLE IF EXISTS treatment_before_afters;

CREATE TABLE treatment_before_afters (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,
    patient_age INTEGER,
    patient_gender VARCHAR(10),
    treatment_count INTEGER,
    treatment_period VARCHAR(50),
    is_published INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO treatment_before_afters SELECT * FROM treatment_before_afters_temp;

DROP TABLE IF EXISTS treatment_before_afters_temp;

CREATE INDEX IF NOT EXISTS idx_before_afters_subcategory ON treatment_before_afters(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_published ON treatment_before_afters(is_published);

-- ============================================
-- 3. treatment_option_mappings テーブルの再構築
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_option_mappings_temp AS
SELECT 
    id,
    COALESCE(subcategory_id_new, treatment_id) AS subcategory_id,
    option_id,
    is_required,
    created_at
FROM treatment_option_mappings;

DROP TABLE IF EXISTS treatment_option_mappings;

CREATE TABLE treatment_option_mappings (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    option_id TEXT NOT NULL REFERENCES treatment_options(id) ON DELETE CASCADE,
    is_required INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(subcategory_id, option_id)
);

INSERT INTO treatment_option_mappings SELECT * FROM treatment_option_mappings_temp;

DROP TABLE IF EXISTS treatment_option_mappings_temp;

CREATE INDEX IF NOT EXISTS idx_treatment_option_mappings_subcategory ON treatment_option_mappings(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_treatment_option_mappings_option ON treatment_option_mappings(option_id);

-- ============================================
-- 4. treatment_details テーブルの再構築（存在する場合）
-- ============================================
-- 注意: treatment_details テーブルが存在する場合のみ実行が必要
-- 実際のテーブル構造に合わせて調整してください

-- ============================================
-- 5. treatment_flows テーブルの再構築（存在する場合）
-- ============================================

-- ============================================
-- 6. treatment_cautions テーブルの再構築（存在する場合）
-- ============================================

-- ============================================
-- 7. treatment_faqs テーブルの再構築（存在する場合）
-- ============================================

-- ============================================
-- 8. treatment_tags テーブルの再構築（存在する場合）
-- ============================================

-- ============================================
-- ビューの更新
-- ============================================

DROP VIEW IF EXISTS v_price_list;

CREATE VIEW IF NOT EXISTS v_price_list AS
SELECT 
    c.name AS category_name,
    sc.name AS subcategory_name,
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
JOIN subcategories sc ON tp.subcategory_id = sc.id
JOIN categories c ON sc.category_id = c.id
WHERE tp.is_active = 1;

