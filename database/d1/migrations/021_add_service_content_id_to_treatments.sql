-- ============================================
-- treatments に service_content_id カラムを追加
-- service_contents (28件) → treatments (231件) の紐付け
-- ============================================

-- 1. service_content_id カラムを追加
ALTER TABLE treatments ADD COLUMN service_content_id TEXT REFERENCES service_contents(id) ON DELETE SET NULL;

-- 2. インデックス作成
CREATE INDEX IF NOT EXISTS idx_treatments_service_content ON treatments(service_content_id);

-- 3. 名前で自動マッチング（完全一致）
UPDATE treatments 
SET service_content_id = (
  SELECT sc.id FROM service_contents sc 
  WHERE sc.name_ja = treatments.name
)
WHERE service_content_id IS NULL;

-- 4. 部分一致でマッチング（名前が含まれる場合）
-- オンダリフト系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'オンダリフト') 
WHERE name LIKE '%オンダ%' AND service_content_id IS NULL;

-- ポテンツァ系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ポテンツァ') 
WHERE name LIKE '%ポテンツァ%' AND service_content_id IS NULL;

-- ウルトラセル/HIFU系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'HIFU ウルトラセルZi') 
WHERE (name LIKE '%ウルトラセル%' OR name LIKE '%HIFU%') AND service_content_id IS NULL;

-- ボトックス系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ボトックス') 
WHERE name LIKE '%ボトックス%' AND service_content_id IS NULL;

-- ヒアルロン酸系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ヒアルロン酸') 
WHERE name LIKE '%ヒアルロン%' AND service_content_id IS NULL;

-- 糸リフト系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = '糸リフト') 
WHERE name LIKE '%糸リフト%' AND service_content_id IS NULL;

-- エリシスセンス系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'エリシスセンス') 
WHERE name LIKE '%エリシス%' AND service_content_id IS NULL;

-- トライフィルプロ系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'トライフィルプロ') 
WHERE name LIKE '%トライフィル%' AND service_content_id IS NULL;

-- サブシジョン系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'サブシジョン') 
WHERE name LIKE '%サブシジョン%' AND service_content_id IS NULL;

-- ハイドラジェントル系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ハイドラジェントル') 
WHERE name LIKE '%ハイドラ%' AND service_content_id IS NULL;

-- ピコレーザー系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ピコレーザー') 
WHERE name LIKE '%ピコ%' AND service_content_id IS NULL;

-- 脂肪溶解注射系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = '脂肪溶解注射') 
WHERE name LIKE '%脂肪溶解%' AND service_content_id IS NULL;

-- ケアシス系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ケアシス') 
WHERE name LIKE '%ケアシス%' AND service_content_id IS NULL;

-- ソプラノ（脱毛）系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ソプラノアイスプラチナム') 
WHERE name LIKE '%ソプラノ%' AND service_content_id IS NULL;

-- マッサージピール系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'マッサージピール') 
WHERE name LIKE '%マッサージピール%' AND service_content_id IS NULL;

-- ミラノリピール系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'ミラノリピール') 
WHERE name LIKE '%ミラノ%' AND service_content_id IS NULL;

-- フォトフェイシャル系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'フォトフェイシャル Stella M22') 
WHERE name LIKE '%フォト%' OR name LIKE '%M22%' AND service_content_id IS NULL;

-- アートメイク系
UPDATE treatments SET service_content_id = (SELECT id FROM service_contents WHERE name_ja = 'アートメイク') 
WHERE name LIKE '%アートメイク%' AND service_content_id IS NULL;

