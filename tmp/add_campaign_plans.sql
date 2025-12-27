-- Add campaign_plans table if not exists
CREATE TABLE IF NOT EXISTS campaign_plans (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    campaign_id TEXT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    treatment_plan_id TEXT NOT NULL REFERENCES treatment_plans(id) ON DELETE CASCADE,
    discount_type VARCHAR(20) NOT NULL DEFAULT 'percentage',
    discount_value INTEGER,
    special_price INTEGER,
    special_price_taxed INTEGER,
    min_sessions INTEGER,
    max_discount_amount INTEGER,
    display_name VARCHAR(100),
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(campaign_id, treatment_plan_id)
);

CREATE INDEX IF NOT EXISTS idx_campaign_plans_campaign ON campaign_plans(campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_plans_plan ON campaign_plans(treatment_plan_id);

