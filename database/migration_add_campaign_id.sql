-- ============================================
-- マイグレーション: treatment_plansにcampaign_idを追加
-- ============================================
-- 
-- 前提条件: campaignsテーブルが存在すること
-- schema_content.sqlを先に実行している必要があります

BEGIN;

-- campaign_idカラムを追加（外部キー制約なしで一旦追加）
ALTER TABLE treatment_plans 
ADD COLUMN IF NOT EXISTS campaign_id UUID;

-- 外部キー制約を追加（campaignsテーブルが存在する場合のみ）
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'campaigns') THEN
        ALTER TABLE treatment_plans 
        ADD CONSTRAINT fk_treatment_plans_campaign 
        FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL;
    END IF;
END $$;

-- インデックス追加
CREATE INDEX IF NOT EXISTS idx_treatment_plans_campaign ON treatment_plans(campaign_id);

COMMIT;

