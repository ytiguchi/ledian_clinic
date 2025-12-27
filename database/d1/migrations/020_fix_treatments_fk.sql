-- ============================================
-- Fix treatments FK to subcategories (drop legacy subcategories_old)
-- ============================================

PRAGMA foreign_keys=off;

DROP VIEW IF EXISTS v_price_list;
DROP VIEW IF EXISTS v_treatments_full;

-- Rebuild treatments with correct FK
CREATE TABLE IF NOT EXISTS treatments_new (
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

INSERT INTO treatments_new (
    id,
    subcategory_id,
    name,
    slug,
    description,
    sort_order,
    is_active,
    created_at,
    updated_at
)
SELECT
    id,
    subcategory_id,
    name,
    slug,
    description,
    sort_order,
    is_active,
    created_at,
    updated_at
FROM treatments;

DROP TABLE IF EXISTS treatments;
ALTER TABLE treatments_new RENAME TO treatments;

CREATE INDEX IF NOT EXISTS idx_treatments_subcategory ON treatments(subcategory_id);

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

-- Remove legacy tables if still present
DROP TABLE IF EXISTS subcategories_old;
DROP TABLE IF EXISTS treatments_backup;

PRAGMA foreign_keys=on;
