-- ============================================
-- レディアンクリニック コンテンツ管理スキーマ
-- 施術詳細ページ用の拡張テーブル
-- ============================================

-- ============================================
-- 施術詳細コンテンツ
-- ============================================

-- 施術の詳細情報（1サブカテゴリにつき1レコード）
-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照（サブカテゴリ = 各施術ページ）
CREATE TABLE treatment_details (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL UNIQUE REFERENCES subcategories(id) ON DELETE CASCADE,
    
    -- 基本テキスト
    tagline VARCHAR(100),                    -- キャッチコピー「切らずにリフトアップ」
    tagline_en VARCHAR(100),                 -- 英語タグライン「Cut-free lifting」
    summary TEXT,                            -- 概要説明（300字以内）
    description TEXT,                        -- 詳細説明（Markdown対応）
    
    -- スペック情報
    duration_min INTEGER,                    -- 施術時間（分）最小
    duration_max INTEGER,                    -- 施術時間（分）最大
    duration_text VARCHAR(50),               -- 施術時間表示テキスト
    downtime_days INTEGER DEFAULT 0,         -- ダウンタイム（日数）
    downtime_text VARCHAR(50),               -- ダウンタイム表示テキスト
    pain_level INTEGER CHECK (pain_level BETWEEN 1 AND 5), -- 痛みレベル1-5
    effect_duration_months INTEGER,          -- 効果持続期間（月）
    effect_duration_text VARCHAR(50),        -- 効果持続表示テキスト
    recommended_sessions INTEGER,            -- 推奨回数
    session_interval_weeks INTEGER,          -- 推奨間隔（週）
    session_interval_text VARCHAR(50),       -- 推奨間隔表示テキスト
    
    -- 人気・表示設定
    popularity_rank INTEGER,                 -- 人気ランキング（1=No.1）
    is_featured BOOLEAN DEFAULT false,       -- 注目施術フラグ
    is_new BOOLEAN DEFAULT false,            -- NEW表示フラグ
    
    -- メディア
    hero_image_url VARCHAR(500),             -- ヒーロー画像
    thumbnail_url VARCHAR(500),              -- サムネイル
    video_url VARCHAR(500),                  -- 動画URL（YouTube等）
    
    -- SEO
    meta_title VARCHAR(100),
    meta_description VARCHAR(200),
    
    -- メタ情報
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
);

-- ============================================
-- お悩み・効果・部位タグ
-- ============================================

-- タグ種別
CREATE TYPE tag_type AS ENUM (
    'concern',     -- お悩み（たるみ、シミ、毛穴など）
    'effect',      -- 効果（リフトアップ、美白など）
    'body_part',   -- 施術部位（顔全体、目元、首など）
    'feature'      -- 特徴（ダウンタイムなし、痛み少ないなど）
);

-- タグマスター
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tag_type tag_type NOT NULL,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) NOT NULL,
    icon VARCHAR(10),                        -- 絵文字アイコン
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(tag_type, slug)
);

-- 施術×タグ紐付け
-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE treatment_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT false,        -- メインタグかどうか
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(subcategory_id, tag_id)
);

-- ============================================
-- 施術フロー（施術の流れ）
-- ============================================

CREATE TABLE treatment_flows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    treatment_id UUID NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,            -- ステップ番号
    title VARCHAR(50) NOT NULL,              -- ステップ名「カウンセリング」
    description TEXT,                        -- 説明文
    duration_minutes INTEGER,                -- 所要時間（分）
    icon VARCHAR(10),                        -- 絵文字アイコン
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(subcategory_id, step_number)
);

-- ============================================
-- 注意事項
-- ============================================

-- 注意事項タイプ
CREATE TYPE caution_type AS ENUM (
    'contraindication',  -- 禁忌（施術を受けられない方）
    'before',            -- 施術前の注意
    'after',             -- 施術後の注意
    'risk'               -- リスク・副作用
);

-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE treatment_cautions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    caution_type caution_type NOT NULL,
    content TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- よくある質問（FAQ）
-- ============================================

-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE treatment_faqs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- ビフォーアフター
-- ============================================

-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照（サブカテゴリ = 各施術ページ）
CREATE TABLE treatment_before_afters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,                            -- 説明文
    patient_age INTEGER,                     -- 患者年齢（任意）
    patient_gender VARCHAR(10),              -- 性別（任意）
    treatment_count INTEGER,                 -- 施術回数
    treatment_period VARCHAR(50),            -- 施術期間「3ヶ月」
    is_published BOOLEAN DEFAULT false,      -- 公開フラグ
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- 関連施術
-- ============================================

-- 関連タイプ
CREATE TYPE relation_type AS ENUM (
    'recommended',   -- おすすめ組み合わせ
    'alternative',   -- 代替施術
    'upgrade',       -- アップグレード施術
    'set_menu'       -- セットメニュー
);

-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE treatment_relations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    related_subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    relation_type relation_type NOT NULL,
    description TEXT,                        -- 関連理由の説明
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(subcategory_id, related_subcategory_id, relation_type),
    CHECK(subcategory_id != related_subcategory_id)
);

-- ============================================
-- 施術ギャラリー（複数画像）
-- ============================================

CREATE TABLE treatment_gallery (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    treatment_id UUID NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    caption VARCHAR(200),
    image_type VARCHAR(20) DEFAULT 'general', -- 'general', 'machine', 'process', 'result'
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- キャンペーン・お知らせ
-- ============================================

CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(500),
    start_date DATE,                                    -- 開始日（NULLは無期限開始）
    end_date DATE,                                      -- 終了日（NULLは無期限）
    campaign_type VARCHAR(20) DEFAULT 'discount',      -- 'discount', 'bundle', 'point', 'referral'
    priority INTEGER DEFAULT 0,                         -- 優先度（複数キャンペーン適用時、数値が大きいほど優先）
    is_published BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON COLUMN campaigns.start_date IS 'キャンペーン開始日（NULLは無期限開始）';
COMMENT ON COLUMN campaigns.end_date IS 'キャンペーン終了日（NULLは無期限）';
COMMENT ON COLUMN campaigns.campaign_type IS 'キャンペーン種別: discount=割引, bundle=セット, point=ポイント, referral=紹介';
COMMENT ON COLUMN campaigns.priority IS '優先度（数値が大きいほど優先、複数キャンペーン適用時）';

-- キャンペーン×施術紐付け（旧: treatment_id単位、新: campaign_plans推奨）
-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE campaign_treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    discount_type VARCHAR(20),               -- 'percentage', 'fixed', 'special_price'
    discount_value INTEGER,                  -- 割引値
    special_price INTEGER,                   -- 特別価格
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(campaign_id, subcategory_id)
);

-- キャンペーン×プラン紐付け（推奨: プラン単位で設定可能）
CREATE TABLE campaign_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    treatment_plan_id UUID NOT NULL REFERENCES treatment_plans(id) ON DELETE CASCADE,
    
    -- 割引設定
    discount_type VARCHAR(20) NOT NULL DEFAULT 'percentage',  -- 'percentage', 'fixed', 'special_price'
    discount_value INTEGER,                                    -- 割引率(%) または 固定額(円)
    special_price INTEGER,                                     -- 特別価格（税抜）
    special_price_taxed INTEGER,                               -- 特別価格（税込）
    
    -- 適用条件（オプション）
    min_sessions INTEGER,                                      -- 最小回数（3回以上等）
    max_discount_amount INTEGER,                               -- 最大割引額の上限
    
    -- 表示設定
    display_name VARCHAR(100),                                 -- 表示名（空の場合はキャンペーン名を使用）
    sort_order INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    UNIQUE(campaign_id, treatment_plan_id)
);

COMMENT ON TABLE campaign_plans IS 'キャンペーン×プラン紐付け（プラン単位で価格を設定）';
COMMENT ON COLUMN campaign_plans.discount_type IS '割引タイプ: percentage=パーセント, fixed=固定額, special_price=特別価格';
COMMENT ON COLUMN campaign_plans.discount_value IS '割引率(%) または 固定割引額(円)';
COMMENT ON COLUMN campaign_plans.special_price IS '特別価格（税抜）。special_priceが設定されている場合はこちらを優先';

-- campaign_plansの更新日時トリガー
CREATE TRIGGER trigger_campaign_plans_updated_at
    BEFORE UPDATE ON campaign_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- サブスクリプションプラン
-- ============================================

CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    monthly_price INTEGER NOT NULL,          -- 月額料金
    monthly_price_taxed INTEGER NOT NULL,    -- 月額料金（税込）
    features JSONB,                          -- 特典リスト
    image_url VARCHAR(500),
    is_popular BOOLEAN DEFAULT false,        -- 人気プランフラグ
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- サブスク×施術紐付け（含まれる施術）
-- 注意: 本番サイト構造に合わせて subcategory_id を直接参照
CREATE TABLE subscription_treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID NOT NULL REFERENCES subscription_plans(id) ON DELETE CASCADE,
    subcategory_id UUID NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    monthly_limit INTEGER,                   -- 月間利用上限回数（NULLは無制限）
    discount_rate INTEGER,                   -- 追加利用時の割引率
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(subscription_id, treatment_id)
);

-- ============================================
-- 外部キー制約の追加（treatment_plans.campaign_id）
-- ============================================

-- treatment_plansのcampaign_idに外部キー制約を追加
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'treatment_plans')
       AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'campaigns')
       AND NOT EXISTS (
           SELECT 1 FROM information_schema.table_constraints 
           WHERE constraint_name = 'fk_treatment_plans_campaign'
       ) THEN
        ALTER TABLE treatment_plans 
        ADD CONSTRAINT fk_treatment_plans_campaign 
        FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL;
    END IF;
END $$;

-- ============================================
-- インデックス
-- ============================================

CREATE INDEX idx_treatment_details_subcategory ON treatment_details(subcategory_id);
CREATE INDEX idx_treatment_tags_subcategory ON treatment_tags(subcategory_id);
CREATE INDEX idx_treatment_tags_tag ON treatment_tags(tag_id);
CREATE INDEX idx_tags_type ON tags(tag_type);
CREATE INDEX idx_treatment_flows_subcategory ON treatment_flows(subcategory_id);
CREATE INDEX idx_treatment_cautions_subcategory ON treatment_cautions(subcategory_id);
CREATE INDEX idx_treatment_faqs_subcategory ON treatment_faqs(subcategory_id);
CREATE INDEX idx_treatment_before_afters_subcategory ON treatment_before_afters(subcategory_id);
CREATE INDEX idx_treatment_relations_subcategory ON treatment_relations(subcategory_id);
CREATE INDEX idx_treatment_relations_related ON treatment_relations(related_subcategory_id);
CREATE INDEX idx_campaigns_dates ON campaigns(start_date, end_date);
CREATE INDEX idx_campaigns_published ON campaigns(is_published);
CREATE INDEX idx_campaigns_priority ON campaigns(priority);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_campaign ON treatment_plans(campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_plans_campaign ON campaign_plans(campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_plans_plan ON campaign_plans(treatment_plan_id);

-- ============================================
-- 更新日時トリガー
-- ============================================

CREATE TRIGGER trigger_treatment_details_updated_at
    BEFORE UPDATE ON treatment_details
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_treatment_faqs_updated_at
    BEFORE UPDATE ON treatment_faqs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_campaigns_updated_at
    BEFORE UPDATE ON campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_subscription_plans_updated_at
    BEFORE UPDATE ON subscription_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 便利なビュー
-- ============================================

-- 施術詳細フルビュー
CREATE VIEW v_treatment_details_full AS
SELECT 
    t.id AS treatment_id,
    t.name AS treatment_name,
    t.slug AS treatment_slug,
    sc.name AS subcategory_name,
    c.name AS category_name,
    td.tagline,
    td.tagline_en,
    td.summary,
    td.duration_text,
    td.downtime_text,
    td.pain_level,
    td.effect_duration_text,
    td.recommended_sessions,
    td.session_interval_text,
    td.popularity_rank,
    td.is_featured,
    td.is_new,
    td.hero_image_url,
    td.thumbnail_url
FROM treatments t
JOIN subcategories sc ON t.subcategory_id = sc.id
JOIN categories c ON sc.category_id = c.id
LEFT JOIN treatment_details td ON t.id = td.treatment_id
WHERE t.is_active = true;

-- お悩み別施術検索ビュー
CREATE VIEW v_treatments_by_concern AS
SELECT 
    tg.name AS concern_name,
    tg.icon AS concern_icon,
    t.id AS treatment_id,
    t.name AS treatment_name,
    td.tagline,
    td.thumbnail_url,
    MIN(tp.price_taxed) AS min_price
FROM tags tg
JOIN treatment_tags tt ON tg.id = tt.tag_id
JOIN treatments t ON tt.treatment_id = t.id
LEFT JOIN treatment_details td ON t.id = td.treatment_id
LEFT JOIN treatment_plans tp ON t.id = tp.treatment_id
WHERE tg.tag_type = 'concern'
  AND t.is_active = true
GROUP BY tg.id, tg.name, tg.icon, t.id, t.name, td.tagline, td.thumbnail_url
ORDER BY tg.sort_order, tt.sort_order;

-- 人気施術ビュー
CREATE VIEW v_popular_treatments AS
SELECT 
    t.id,
    t.name,
    c.name AS category_name,
    td.tagline,
    td.thumbnail_url,
    td.popularity_rank,
    MIN(tp.price_taxed) AS min_price
FROM treatments t
JOIN subcategories sc ON t.subcategory_id = sc.id
JOIN categories c ON sc.category_id = c.id
JOIN treatment_details td ON t.id = td.treatment_id
LEFT JOIN treatment_plans tp ON t.id = tp.treatment_id
WHERE td.popularity_rank IS NOT NULL
  AND t.is_active = true
GROUP BY t.id, t.name, c.name, td.tagline, td.thumbnail_url, td.popularity_rank
ORDER BY td.popularity_rank;

-- 公開中キャンペーンビュー
CREATE VIEW v_active_campaigns AS
SELECT 
    c.*,
    COUNT(DISTINCT ct.treatment_id) AS treatment_count,
    COUNT(DISTINCT cp.treatment_plan_id) AS plan_count
FROM campaigns c
LEFT JOIN campaign_treatments ct ON c.id = ct.campaign_id
LEFT JOIN campaign_plans cp ON c.id = cp.campaign_id
WHERE c.is_published = true
  AND (c.start_date IS NULL OR c.start_date <= CURRENT_DATE)
  AND (c.end_date IS NULL OR c.end_date >= CURRENT_DATE)
GROUP BY c.id
ORDER BY c.sort_order;

-- キャンペーン適用中プランビュー（期間・優先度考慮）
CREATE VIEW v_active_campaign_plans AS
SELECT DISTINCT ON (tp.id)
    tp.id AS treatment_plan_id,
    tp.treatment_id,
    t.name AS treatment_name,
    tp.plan_name,
    tp.price AS original_price,
    tp.price_taxed AS original_price_taxed,
    c.id AS campaign_id,
    c.title AS campaign_title,
    c.start_date AS campaign_start_date,
    c.end_date AS campaign_end_date,
    cp.discount_type,
    cp.discount_value,
    cp.special_price,
    cp.special_price_taxed,
    CASE 
        WHEN cp.special_price_taxed IS NOT NULL THEN cp.special_price_taxed
        WHEN cp.special_price IS NOT NULL THEN FLOOR(cp.special_price * 1.1)
        WHEN cp.discount_type = 'percentage' AND cp.discount_value IS NOT NULL THEN
            FLOOR((tp.price - FLOOR(tp.price * cp.discount_value / 100.0)) * 1.1)
        WHEN cp.discount_type = 'fixed' AND cp.discount_value IS NOT NULL THEN
            FLOOR(GREATEST(tp.price - cp.discount_value, 0) * 1.1)
        ELSE tp.price_taxed
    END AS campaign_price_taxed,
    CASE 
        WHEN cp.special_price IS NOT NULL THEN cp.special_price
        WHEN cp.discount_type = 'percentage' AND cp.discount_value IS NOT NULL THEN
            tp.price - FLOOR(tp.price * cp.discount_value / 100.0)
        WHEN cp.discount_type = 'fixed' AND cp.discount_value IS NOT NULL THEN
            GREATEST(tp.price - cp.discount_value, 0)
        ELSE NULL
    END AS campaign_price
FROM treatment_plans tp
JOIN treatments t ON tp.treatment_id = t.id
JOIN campaign_plans cp ON tp.id = cp.treatment_plan_id
JOIN campaigns c ON cp.campaign_id = c.id
WHERE c.is_published = true
  AND (c.start_date IS NULL OR c.start_date <= CURRENT_DATE)
  AND (c.end_date IS NULL OR c.end_date >= CURRENT_DATE)
  AND tp.is_active = true
  AND t.is_active = true
ORDER BY tp.id, c.priority DESC, c.start_date DESC;

COMMENT ON VIEW v_active_campaign_plans IS '現在適用中のキャンペーンプラン一覧（期間・優先度考慮、プランごとに最優先キャンペーンのみ）';

