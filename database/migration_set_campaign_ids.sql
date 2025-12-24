-- ============================================
-- campaign_idを設定するSQL
-- campaignsテーブルにデータ投入後、このスクリプトでcampaign_idを設定
-- ============================================

-- 注意: campaignsテーブルにデータが投入されていることを前提とします
-- campaigns.jsonのデータをcampaignsテーブルに投入してから実行してください

BEGIN;

-- Holiday Campaign (holiday-2024)
UPDATE treatment_plans tp
SET campaign_id = c.id
FROM campaigns c
WHERE c.slug = 'holiday-2024'
  AND tp.campaign_price IS NOT NULL
  AND tp.campaign_price < tp.price
  -- オンダリフト、ポテンツァ、ハイフのプランを対象（実際のtreatment_idに合わせて調整が必要）
  AND EXISTS (
      SELECT 1 FROM treatments t
      JOIN subcategories sc ON t.subcategory_id = sc.id
      WHERE t.id = tp.treatment_id
      AND (sc.name LIKE '%オンダリフト%' 
           OR sc.name LIKE '%ポテンツァ%'
           OR sc.name LIKE '%ハイフ%'
           OR t.name LIKE '%オンダリフト%'
           OR t.name LIKE '%ポテンツァ%'
           OR t.name LIKE '%ハイフ%')
  );

-- アートメイク発売記念 (artmake-launch)
UPDATE treatment_plans tp
SET campaign_id = c.id
FROM campaigns c
WHERE c.slug = 'artmake-launch'
  AND tp.campaign_price IS NOT NULL
  AND tp.campaign_price < tp.price
  AND EXISTS (
      SELECT 1 FROM treatments t
      WHERE t.id = tp.treatment_id
      AND (t.name LIKE '%アートメイク%' OR t.name LIKE '%眉%')
  );

COMMIT;

-- 確認用クエリ
-- SELECT 
--     tp.id,
--     t.name AS treatment_name,
--     tp.plan_name,
--     tp.price,
--     tp.campaign_price,
--     c.title AS campaign_title
-- FROM treatment_plans tp
-- JOIN treatments t ON tp.treatment_id = t.id
-- LEFT JOIN campaigns c ON tp.campaign_id = c.id
-- WHERE tp.campaign_price IS NOT NULL
-- ORDER BY c.title, t.name;

