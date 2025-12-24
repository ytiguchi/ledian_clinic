-- ============================================
-- レディアンクリニック メニュー管理 (Cloudflare D1向け)
-- SQLite互換スキーマ：ENUM/拡張/トリガーなし、UUIDはTEXTで扱う
-- ============================================

-- UUID代替: TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16))))
-- 日時: DATETIME DEFAULT (datetime('now'))
-- BOOL: INTEGER 0/1

-- plan_type ENUM の代替
-- CHECK (plan_type IN ('single','course','trial','monitor','campaign'))

-- ============================================
-- マスターテーブル
-- ============================================

CREATE TABLE IF NOT EXISTS categories (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS subcategories (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(category_id, slug)
);

CREATE TABLE IF NOT EXISTS treatments (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    description TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(subcategory_id, slug)
);

-- ============================================
-- 料金プラン
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_plans (
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

-- ============================================
-- オプション・薬剤
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_options (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    is_global INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS treatment_option_mappings (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    option_id TEXT NOT NULL REFERENCES treatment_options(id) ON DELETE CASCADE,
    is_required INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(treatment_id, option_id)
);

CREATE TABLE IF NOT EXISTS medications (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    unit VARCHAR(20) NOT NULL DEFAULT 'cc',
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS medication_plans (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    medication_id TEXT NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
    quantity VARCHAR(50) NOT NULL,
    sessions INTEGER,
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    campaign_price INTEGER,
    cost_rate REAL,
    supply_cost INTEGER,
    staff_cost INTEGER,
    total_cost INTEGER,
    staff_discount_rate INTEGER,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- インデックス
-- ============================================

CREATE INDEX IF NOT EXISTS idx_subcategories_category ON subcategories(category_id);
CREATE INDEX IF NOT EXISTS idx_treatments_subcategory ON treatments(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_treatment ON treatment_plans(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_type ON treatment_plans(plan_type);
CREATE INDEX IF NOT EXISTS idx_medication_plans_medication ON medication_plans(medication_id);

-- ============================================
-- ビュー相当（APIで組み立てる想定だが簡易ビューを残す）
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
