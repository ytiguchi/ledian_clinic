-- treatment_before_afters テーブルに service_content_id カラムを追加
-- これにより症例写真をサービスコンテンツに直接紐づけられるようになる

ALTER TABLE treatment_before_afters ADD COLUMN service_content_id TEXT;

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_before_afters_service_content ON treatment_before_afters(service_content_id);

-- 既存データをservice_contentsに紐づける（subcategory経由）
UPDATE treatment_before_afters 
SET service_content_id = (
  SELECT sc.id 
  FROM service_contents sc 
  WHERE sc.subcategory_id = treatment_before_afters.subcategory_id
  LIMIT 1
)
WHERE service_content_id IS NULL;

