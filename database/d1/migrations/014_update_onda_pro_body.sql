-- ============================================
-- ONDA PRO（体）: 説明文整形 + 料金（1回）更新 + リスク登録
-- ============================================
-- 目的:
-- - 「オンダリフトボディ」(treatments) の説明/詳細を整形して反映
-- - 1回プラン（税込36,300円）へ更新
-- - リスク・副作用を treatment_cautions に登録
-- - service_contents(onda-pro) にも短い概要を反映（テーブル未作成環境のため作成も兼ねる）

BEGIN TRANSACTION;

-- ============================================
-- 0. service_contents 系テーブル（存在しない環境向け）
-- ============================================
CREATE TABLE IF NOT EXISTS service_contents (
  id TEXT PRIMARY KEY,
  subcategory_id TEXT,
  name_ja TEXT NOT NULL,
  name_en TEXT,
  slug TEXT NOT NULL UNIQUE,
  source_url TEXT,
  about_subtitle TEXT,
  about_description TEXT,
  hero_image_url TEXT,
  is_published INTEGER NOT NULL DEFAULT 0,
  scraped_at TEXT,
  last_edited_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS service_features (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  icon_url TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS service_recommendations (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL,
  text TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS service_overviews (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL UNIQUE,
  duration TEXT,
  downtime TEXT,
  frequency TEXT,
  makeup TEXT,
  bathing TEXT,
  contraindications TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS service_faqs (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL,
  question TEXT NOT NULL,
  answer TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_service_contents_subcategory ON service_contents(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_service_contents_slug ON service_contents(slug);
CREATE INDEX IF NOT EXISTS idx_service_features_service ON service_features(service_content_id);
CREATE INDEX IF NOT EXISTS idx_service_recommendations_service ON service_recommendations(service_content_id);
CREATE INDEX IF NOT EXISTS idx_service_faqs_service ON service_faqs(service_content_id);

-- ============================================
-- 1. ONDA PRO（service_contents: onda-pro）概要の反映
-- ============================================
INSERT OR IGNORE INTO service_contents (
  id, subcategory_id, name_ja, name_en, slug, source_url,
  about_subtitle, about_description, hero_image_url,
  is_published, scraped_at, last_edited_at
) VALUES (
  'onda_pro',
  NULL,
  'オンダプロ',
  'ONDA PRO',
  'onda-pro',
  'https://ledianclinic.jp/service/onda-pro/',
  '特殊なマイクロ波で脂肪細胞を加熱・分解',
  'イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解します。\n\n二の腕・お腹・太もも・背中など、気になる部分の部分痩せやボディラインの引き締めに効果が期待できます。\n\n脂肪の減少と同時に、肌のハリ改善やセルライトの軽減も期待できます。\n\n痛み・ダウンタイムが少なく、施術直後から日常生活OKです。',
  NULL,
  0,
  datetime('now'),
  datetime('now')
);

UPDATE service_contents
SET
  about_subtitle = '特殊なマイクロ波で脂肪細胞を加熱・分解',
  about_description = 'イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解します。\n\n二の腕・お腹・太もも・背中など、気になる部分の部分痩せやボディラインの引き締めに効果が期待できます。\n\n脂肪の減少と同時に、肌のハリ改善やセルライトの軽減も期待できます。\n\n痛み・ダウンタイムが少なく、施術直後から日常生活OKです。',
  last_edited_at = datetime('now'),
  updated_at = datetime('now')
WHERE slug = 'onda-pro';

-- ============================================
-- 2. オンダリフトボディ（treatments）説明を更新
-- ============================================
UPDATE treatments
SET
  description = '二の腕・お腹・太もも・背中など、気になる部位の部分痩せ・引き締め（ONDA PRO／体用ハンドピース：ディープ）',
  updated_at = datetime('now')
WHERE id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f';

-- ============================================
-- 3. treatment_details（Markdown）を作成/更新
-- ============================================
DELETE FROM treatment_details
WHERE treatment_id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f';

INSERT INTO treatment_details (
  id,
  treatment_id,
  tagline,
  summary,
  description,
  downtime_days,
  downtime_text,
  pain_level,
  meta_title,
  meta_description,
  created_at,
  updated_at
) SELECT
  'onda_pro_body_detail',
  '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f',
  '特殊なマイクロ波で脂肪細胞を加熱・分解',
  'イタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解します。部分痩せと同時に肌のハリ改善やセルライト軽減も期待でき、痛み・ダウンタイムが少なく直後から日常生活が可能です。',
  '## 概要\n\nイタリア製痩身機器「ONDA PRO」を使用し、特殊なマイクロ波で脂肪細胞を加熱・分解します。\n\n## 期待できる効果\n\n- 二の腕・お腹・太もも・背中などの部分痩せ、ボディラインの引き締め\n- 肌のハリ改善、セルライトの軽減\n- 痛み・ダウンタイムが少なく、施術直後から日常生活OK\n\n## 期間・回数\n\n- 1回：体用ハンドピース（ディープ）使用\n\n## 費用\n\n- 1回：税込36,300円\n\n## リスク・副作用\n\n- 一時的な赤み、熱感、むくみ、筋肉痛のような違和感\n- 稀に火傷や色素沈着\n- 効果には個人差があります\n',
  0,
  'ほぼなし',
  2,
  'ONDA PRO（体）',
  'ONDA PROを使用した医療痩身。マイクロ波で脂肪細胞を加熱・分解し、部分痩せと引き締めを目指します。',
  datetime('now'),
  datetime('now')
WHERE EXISTS (
  SELECT 1 FROM treatments WHERE id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f'
);

-- ============================================
-- 4. リスク・副作用（treatment_cautions）
-- ============================================
DELETE FROM treatment_cautions
WHERE treatment_id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f'
  AND caution_type = 'risk';

INSERT INTO treatment_cautions (id, treatment_id, caution_type, content, sort_order, created_at)
SELECT
  'onda_pro_body_risk_1',
  '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f',
  'risk',
  '一時的な赤み、熱感、むくみ、筋肉痛のような違和感',
  1,
  datetime('now')
WHERE EXISTS (
  SELECT 1 FROM treatments WHERE id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f'
);

INSERT INTO treatment_cautions (id, treatment_id, caution_type, content, sort_order, created_at)
SELECT
  'onda_pro_body_risk_2',
  '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f',
  'risk',
  '稀に火傷や色素沈着',
  2,
  datetime('now')
WHERE EXISTS (
  SELECT 1 FROM treatments WHERE id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f'
);

INSERT INTO treatment_cautions (id, treatment_id, caution_type, content, sort_order, created_at)
SELECT
  'onda_pro_body_risk_3',
  '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f',
  'risk',
  '効果には個人差があります',
  3,
  datetime('now')
WHERE EXISTS (
  SELECT 1 FROM treatments WHERE id = '8ea67ada-cc5b-4ef0-bca3-3fa1e713628f'
);

-- ============================================
-- 5. 料金（treatment_plans）: 1回（税込36,300円）へ更新
-- ============================================
UPDATE treatment_plans
SET
  plan_name = '1回',
  plan_type = 'single',
  sessions = 1,
  quantity = '体用ハンドピース(ディープ)',
  price = 33000,
  price_taxed = 36300,
  price_per_session = 33000,
  price_per_session_taxed = 36300
WHERE id = 'c42408ce-2837-4e3c-9bfb-c23d89cb36f0';

COMMIT;

