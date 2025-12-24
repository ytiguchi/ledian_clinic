-- ============================================
-- キャンペーン管理スキーマ（改善版）
-- 既存のcampaigns/campaign_treatmentsを改良
-- ============================================

-- ============================================
-- キャンペーンマスター（既存を改善）
-- ============================================

-- campaignsテーブル（既存を拡張）
ALTER TABLE campaigns 
ADD COLUMN IF NOT EXISTS campaign_type VARCHAR(20) DEFAULT 'discount',  -- 'discount', 'bundle', 'point', 'referral'
ADD COLUMN IF NOT EXISTS priority INTEGER DEFAULT 0;                    -- 優先度（複数キャンペーン適用時）

COMMENT ON COLUMN campaigns.campaign_type IS 'キャンペーン種別: discount=割引, bundle=セット, point=ポイント, referral=紹介';
COMMENT ON COLUMN campaigns.priority IS '優先度（数値が大きいほど優先、複数キャンペーン適用時）';

-- ============================================
-- キャンペーン×プラン紐付け（改善版）
-- ============================================

-- 既存のcampaign_treatmentsをcampaign_plansに拡張
CREATE TABLE IF NOT EXISTS campaign_plans (
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

-- インデックス
CREATE INDEX IF NOT EXISTS idx_campaign_plans_campaign ON campaign_plans(campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_plans_plan ON campaign_plans(treatment_plan_id);

-- 更新日時トリガー
CREATE TRIGGER trigger_campaign_plans_updated_at
    BEFORE UPDATE ON campaign_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- キャンペーン価格計算関数
-- ============================================

CREATE OR REPLACE FUNCTION calculate_campaign_price(
    p_treatment_plan_id UUID,
    p_campaign_date DATE DEFAULT CURRENT_DATE
) RETURNS TABLE (
    campaign_id UUID,
    campaign_title VARCHAR(100),
    original_price INTEGER,
    original_price_taxed INTEGER,
    campaign_price INTEGER,
    campaign_price_taxed INTEGER,
    discount_type VARCHAR(20),
    discount_amount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id AS campaign_id,
        c.title AS campaign_title,
        tp.price AS original_price,
        tp.price_taxed AS original_price_taxed,
        CASE 
            WHEN cp.special_price IS NOT NULL THEN cp.special_price
            WHEN cp.discount_type = 'percentage' AND cp.discount_value IS NOT NULL THEN
                tp.price - FLOOR(tp.price * cp.discount_value / 100.0)
            WHEN cp.discount_type = 'fixed' AND cp.discount_value IS NOT NULL THEN
                GREATEST(tp.price - cp.discount_value, 0)
            ELSE tp.price
        END AS campaign_price,
        CASE 
            WHEN cp.special_price_taxed IS NOT NULL THEN cp.special_price_taxed
            WHEN cp.special_price IS NOT NULL THEN FLOOR(cp.special_price * 1.1)
            WHEN cp.discount_type = 'percentage' AND cp.discount_value IS NOT NULL THEN
                FLOOR((tp.price - FLOOR(tp.price * cp.discount_value / 100.0)) * 1.1)
            WHEN cp.discount_type = 'fixed' AND cp.discount_value IS NOT NULL THEN
                FLOOR(GREATEST(tp.price - cp.discount_value, 0) * 1.1)
            ELSE tp.price_taxed
        END AS campaign_price_taxed,
        cp.discount_type,
        CASE 
            WHEN cp.discount_type = 'percentage' AND cp.discount_value IS NOT NULL THEN
                FLOOR(tp.price * cp.discount_value / 100.0)
            WHEN cp.discount_type = 'fixed' AND cp.discount_value IS NOT NULL THEN
                cp.discount_value
            ELSE 0
        END AS discount_amount
    FROM treatment_plans tp
    JOIN campaign_plans cp ON tp.id = cp.treatment_plan_id
    JOIN campaigns c ON cp.campaign_id = c.id
    WHERE tp.id = p_treatment_plan_id
      AND c.is_published = true
      AND (c.start_date IS NULL OR c.start_date <= p_campaign_date)
      AND (c.end_date IS NULL OR c.end_date >= p_campaign_date)
    ORDER BY c.priority DESC, c.start_date DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION calculate_campaign_price IS 'キャンペーン適用中の価格を計算（期間・優先度を考慮）';

-- ============================================
-- キャンペーン適用中プランビュー
-- ============================================

CREATE OR REPLACE VIEW v_active_campaign_plans AS
SELECT 
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
    END AS campaign_price_taxed
FROM treatment_plans tp
JOIN treatments t ON tp.treatment_id = t.id
JOIN campaign_plans cp ON tp.id = cp.treatment_plan_id
JOIN campaigns c ON cp.campaign_id = c.id
WHERE c.is_published = true
  AND (c.start_date IS NULL OR c.start_date <= CURRENT_DATE)
  AND (c.end_date IS NULL OR c.end_date >= CURRENT_DATE)
  AND tp.is_active = true
  AND t.is_active = true;

COMMENT ON VIEW v_active_campaign_plans IS '現在適用中のキャンペーンプラン一覧（期間フィルタ済み）';

-- ============================================
-- treatment_plansのcampaign_priceを自動更新する関数（オプション）
-- ============================================

CREATE OR REPLACE FUNCTION sync_campaign_prices()
RETURNS void AS $$
BEGIN
    -- campaign_plansからtreatment_plansのcampaign_price/campaign_idを更新
    UPDATE treatment_plans tp
    SET 
        campaign_id = acp.campaign_id,
        campaign_price = CASE 
            WHEN acp.special_price IS NOT NULL THEN acp.special_price
            WHEN acp.discount_type = 'percentage' AND acp.discount_value IS NOT NULL THEN
                tp.price - FLOOR(tp.price * acp.discount_value / 100.0)
            WHEN acp.discount_type = 'fixed' AND acp.discount_value IS NOT NULL THEN
                GREATEST(tp.price - acp.discount_value, 0)
            ELSE NULL
        END,
        campaign_price_taxed = acp.campaign_price_taxed,
        updated_at = NOW()
    FROM (
        SELECT DISTINCT ON (treatment_plan_id)
            treatment_plan_id,
            campaign_id,
            special_price,
            discount_type,
            discount_value,
            campaign_price_taxed
        FROM v_active_campaign_plans
        ORDER BY treatment_plan_id, priority DESC
    ) acp
    WHERE tp.id = acp.treatment_plan_id;
    
    -- キャンペーン適用外のプランはcampaign_priceをNULLに
    UPDATE treatment_plans tp
    SET 
        campaign_id = NULL,
        campaign_price = NULL,
        campaign_price_taxed = NULL,
        updated_at = NOW()
    WHERE tp.campaign_price IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM v_active_campaign_plans acp
          WHERE acp.treatment_plan_id = tp.id
      );
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION sync_campaign_prices IS 'campaign_plansからtreatment_plansのcampaign_priceを同期（定期実行推奨）';

-- ============================================
-- 使用例・クエリ
-- ============================================

-- 例1: 特定プランのキャンペーン価格を取得
-- SELECT * FROM calculate_campaign_price('プランID'::UUID);

-- 例2: 現在適用中の全キャンペーンプラン
-- SELECT * FROM v_active_campaign_plans ORDER BY campaign_title, treatment_name;

-- 例3: キャンペーン価格を同期（定期実行）
-- SELECT sync_campaign_prices();

