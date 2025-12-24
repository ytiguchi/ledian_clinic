-- ============================================
-- レディアンクリニック メニュー管理システム
-- PostgreSQL Schema
-- ============================================

-- 拡張機能
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- マスターテーブル
-- ============================================

-- 大カテゴリ（スキンケア、医療脱毛、アートメイク等）
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 小カテゴリ（ハイフ、ポテンツァ、ダーマペン等）
CREATE TABLE subcategories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(category_id, slug)
);

-- 施術（ウルトラセルZi、Stella M22等）
CREATE TABLE treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    description TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(subcategory_id, slug)
);

-- ============================================
-- 料金プランテーブル
-- ============================================

-- プラン種別
CREATE TYPE plan_type AS ENUM (
    'single',      -- 単発
    'course',      -- 回数コース
    'trial',       -- 初回お試し
    'monitor',     -- モニター価格
    'campaign'     -- キャンペーン
);

-- 施術プラン（料金体系）
-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照（サブカテゴリ = 各施術ページ）
CREATE TABLE treatment_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    
    -- プラン情報
    plan_name VARCHAR(100) NOT NULL,        -- "200S", "全顔", "1回" 等
    plan_type plan_type NOT NULL DEFAULT 'single',
    sessions INTEGER,                        -- 回数（NULLは単発や個数制）
    quantity VARCHAR(50),                    -- 個数表記（"1cc", "10単位" 等）
    
    -- 価格情報
    price INTEGER NOT NULL,                  -- 税抜価格
    price_taxed INTEGER NOT NULL,            -- 税込価格
    price_per_session INTEGER,               -- 1回あたり税抜
    price_per_session_taxed INTEGER,         -- 1回あたり税込
    
    -- キャンペーン価格
    campaign_id UUID,  -- キャンペーンID（campaignsテーブル参照、schema_content.sqlで外部キー制約を追加）
    campaign_price INTEGER,
    campaign_price_taxed INTEGER,
    
    -- 原価情報
    cost_rate DECIMAL(5,2),                  -- 原価率（%）
    campaign_cost_rate DECIMAL(5,2),         -- キャンペーン原価率
    supply_cost INTEGER,                     -- 備品原価
    staff_cost INTEGER,                      -- 医師・看護師原価
    total_cost INTEGER,                      -- 原価合計
    
    -- 旧価格・その他
    old_price INTEGER,                       -- 旧定価
    staff_discount_rate INTEGER,             -- 社販OFF（%）
    
    -- メタ情報
    notes TEXT,                              -- 備考
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- オプション・追加メニュー
-- ============================================

-- 追加オプション（麻酔、薬剤追加等）
CREATE TABLE treatment_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    is_global BOOLEAN NOT NULL DEFAULT false,  -- 全施術共通かどうか
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 施術とオプションの関連
-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE treatment_option_mappings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES treatment_options(id) ON DELETE CASCADE,
    is_required BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(subcategory_id, option_id)
);

-- ============================================
-- 薬剤マスター（ポテンツァ、エリシス等で使用）
-- ============================================

CREATE TABLE medications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    unit VARCHAR(20) NOT NULL DEFAULT 'cc',  -- 単位（cc, mg等）
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 薬剤料金プラン
CREATE TABLE medication_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    medication_id UUID NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
    quantity VARCHAR(50) NOT NULL,           -- "2cc", "4cc" 等
    sessions INTEGER,                        -- 回数
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    campaign_price INTEGER,
    cost_rate DECIMAL(5,2),
    supply_cost INTEGER,
    staff_cost INTEGER,
    total_cost INTEGER,
    staff_discount_rate INTEGER,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- インデックス
-- ============================================

CREATE INDEX idx_subcategories_category ON subcategories(category_id);
CREATE INDEX idx_treatments_subcategory ON treatments(subcategory_id);
CREATE INDEX idx_treatment_plans_subcategory ON treatment_plans(subcategory_id);
CREATE INDEX idx_treatment_plans_type ON treatment_plans(plan_type);
CREATE INDEX idx_medication_plans_medication ON medication_plans(medication_id);

-- 全文検索用
CREATE INDEX idx_treatments_name_gin ON treatments USING gin(to_tsvector('simple', name));
CREATE INDEX idx_categories_name_gin ON categories USING gin(to_tsvector('simple', name));

-- ============================================
-- 更新日時自動更新トリガー
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_subcategories_updated_at
    BEFORE UPDATE ON subcategories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_treatments_updated_at
    BEFORE UPDATE ON treatments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_treatment_plans_updated_at
    BEFORE UPDATE ON treatment_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_treatment_options_updated_at
    BEFORE UPDATE ON treatment_options
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_medications_updated_at
    BEFORE UPDATE ON medications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_medication_plans_updated_at
    BEFORE UPDATE ON medication_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- ビュー（よく使うクエリ用）
-- ============================================

-- 施術一覧ビュー（カテゴリ情報付き）
CREATE VIEW v_treatments_full AS
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

-- 料金一覧ビュー
CREATE VIEW v_price_list AS
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
WHERE tp.is_active = true
ORDER BY c.sort_order, sc.sort_order, t.sort_order, tp.sort_order;

