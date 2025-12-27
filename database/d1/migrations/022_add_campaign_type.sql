-- Add campaign_type column to campaigns table for filtering
-- campaign_type: 'campaign' (キャンペーン), 'new_service' (新サービス), 'news' (お知らせ)

ALTER TABLE campaigns ADD COLUMN campaign_type TEXT DEFAULT 'campaign';

-- Update existing campaigns based on title patterns (optional - adjust as needed)
-- Example: titles containing 'キャンペーン' -> 'campaign'
--          titles containing 'スタート', '始動', '発売', '導入' -> 'new_service'
--          titles containing '重要', 'お知らせ', '改定' -> 'news'

UPDATE campaigns SET campaign_type = 'news' 
WHERE title LIKE '%重要%' OR title LIKE '%改定%' OR title LIKE '%お知らせ%';

UPDATE campaigns SET campaign_type = 'new_service' 
WHERE (title LIKE '%スタート%' OR title LIKE '%始動%' OR title LIKE '%発売%' OR title LIKE '%導入%' OR title LIKE '%はじめました%')
AND campaign_type = 'campaign';

-- Create index for efficient filtering
CREATE INDEX IF NOT EXISTS idx_campaigns_type ON campaigns(campaign_type);

