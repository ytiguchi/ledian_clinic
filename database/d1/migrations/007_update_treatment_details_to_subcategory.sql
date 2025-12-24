-- ============================================
-- マイグレーション: treatment_details 系テーブルを subcategory_id ベースに変更
-- ============================================
-- treatment_details, treatment_flows, treatment_cautions, treatment_faqs, treatment_tags
-- を subcategory_id ベースに変更します。

-- ============================================
-- 1. treatment_details テーブルの変更
-- ============================================

-- 既存のテーブルが存在する場合のみ実行
-- まず、新しいカラムを追加
-- 注意: SQLiteでは IF NOT EXISTS が使えないため、エラーを無視するか、
-- アプリケーション側でテーブルの存在確認が必要

-- treatment_details が存在する場合の処理
-- ALTER TABLE treatment_details ADD COLUMN subcategory_id_new TEXT;
-- UPDATE treatment_details SET subcategory_id_new = (SELECT subcategory_id FROM treatments WHERE treatments.id = treatment_details.treatment_id) WHERE EXISTS (SELECT 1 FROM treatments WHERE treatments.id = treatment_details.treatment_id);

-- テーブル再作成
CREATE TABLE IF NOT EXISTS treatment_details_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL UNIQUE REFERENCES subcategories(id) ON DELETE CASCADE,
    tagline VARCHAR(100),
    tagline_en VARCHAR(100),
    summary TEXT,
    description TEXT,
    duration_min INTEGER,
    duration_max INTEGER,
    duration_text VARCHAR(50),
    downtime_days INTEGER DEFAULT 0,
    downtime_text VARCHAR(50),
    pain_level INTEGER CHECK (pain_level BETWEEN 1 AND 5),
    effect_duration_months INTEGER,
    effect_duration_text VARCHAR(50),
    recommended_sessions INTEGER,
    session_interval_weeks INTEGER,
    session_interval_text VARCHAR(50),
    popularity_rank INTEGER,
    is_featured INTEGER DEFAULT 0,
    is_new INTEGER DEFAULT 0,
    hero_image_url VARCHAR(500),
    thumbnail_url VARCHAR(500),
    video_url VARCHAR(500),
    meta_title VARCHAR(100),
    meta_description VARCHAR(200),
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- データ移行（既存の treatment_details がある場合）
INSERT INTO treatment_details_new (
    id, subcategory_id, tagline, tagline_en, summary, description,
    duration_min, duration_max, duration_text, downtime_days, downtime_text,
    pain_level, effect_duration_months, effect_duration_text,
    recommended_sessions, session_interval_weeks, session_interval_text,
    popularity_rank, is_featured, is_new, hero_image_url, thumbnail_url,
    video_url, meta_title, meta_description, created_at, updated_at
)
SELECT 
    td.id,
    t.subcategory_id,
    td.tagline, td.tagline_en, td.summary, td.description,
    td.duration_min, td.duration_max, td.duration_text,
    td.downtime_days, td.downtime_text,
    td.pain_level, td.effect_duration_months, td.effect_duration_text,
    td.recommended_sessions, td.session_interval_weeks, td.session_interval_text,
    td.popularity_rank, td.is_featured, td.is_new,
    td.hero_image_url, td.thumbnail_url, td.video_url,
    td.meta_title, td.meta_description, td.created_at, td.updated_at
FROM treatment_details td
JOIN treatments t ON td.treatment_id = t.id
WHERE EXISTS (SELECT 1 FROM treatments WHERE treatments.id = td.treatment_id);

-- 旧テーブルを削除して新テーブルにリネーム
DROP TABLE IF EXISTS treatment_details;
ALTER TABLE treatment_details_new RENAME TO treatment_details;

CREATE INDEX IF NOT EXISTS idx_treatment_details_subcategory ON treatment_details(subcategory_id);

-- ============================================
-- 2. treatment_flows テーブルの変更
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_flows_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,
    title VARCHAR(50) NOT NULL,
    description TEXT,
    duration_minutes INTEGER,
    icon VARCHAR(10),
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(subcategory_id, step_number)
);

INSERT INTO treatment_flows_new (
    id, subcategory_id, step_number, title, description, duration_minutes, icon, created_at
)
SELECT 
    tf.id,
    t.subcategory_id,
    tf.step_number, tf.title, tf.description, tf.duration_minutes, tf.icon, tf.created_at
FROM treatment_flows tf
JOIN treatments t ON tf.treatment_id = t.id
WHERE EXISTS (SELECT 1 FROM treatments WHERE treatments.id = tf.treatment_id);

DROP TABLE IF EXISTS treatment_flows;
ALTER TABLE treatment_flows_new RENAME TO treatment_flows;

CREATE INDEX IF NOT EXISTS idx_treatment_flows_subcategory ON treatment_flows(subcategory_id);

-- ============================================
-- 3. treatment_cautions テーブルの変更
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_cautions_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    caution_type VARCHAR(20) NOT NULL CHECK (caution_type IN ('contraindication', 'before', 'after', 'risk')),
    content TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO treatment_cautions_new (
    id, subcategory_id, caution_type, content, sort_order, created_at
)
SELECT 
    tc.id,
    t.subcategory_id,
    tc.caution_type, tc.content, tc.sort_order, tc.created_at
FROM treatment_cautions tc
JOIN treatments t ON tc.treatment_id = t.id
WHERE EXISTS (SELECT 1 FROM treatments WHERE treatments.id = tc.treatment_id);

DROP TABLE IF EXISTS treatment_cautions;
ALTER TABLE treatment_cautions_new RENAME TO treatment_cautions;

CREATE INDEX IF NOT EXISTS idx_treatment_cautions_subcategory ON treatment_cautions(subcategory_id);

-- ============================================
-- 4. treatment_faqs テーブルの変更
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_faqs_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_published INTEGER DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO treatment_faqs_new (
    id, subcategory_id, question, answer, sort_order, is_published, created_at, updated_at
)
SELECT 
    tfq.id,
    t.subcategory_id,
    tfq.question, tfq.answer, tfq.sort_order, tfq.is_published, tfq.created_at, tfq.updated_at
FROM treatment_faqs tfq
JOIN treatments t ON tfq.treatment_id = t.id
WHERE EXISTS (SELECT 1 FROM treatments WHERE treatments.id = tfq.treatment_id);

DROP TABLE IF EXISTS treatment_faqs;
ALTER TABLE treatment_faqs_new RENAME TO treatment_faqs;

CREATE INDEX IF NOT EXISTS idx_treatment_faqs_subcategory ON treatment_faqs(subcategory_id);

-- ============================================
-- 5. treatment_tags テーブルの変更
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_tags_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    is_primary INTEGER DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(subcategory_id, tag_id)
);

INSERT INTO treatment_tags_new (
    id, subcategory_id, tag_id, is_primary, sort_order, created_at
)
SELECT 
    tt.id,
    t.subcategory_id,
    tt.tag_id, tt.is_primary, tt.sort_order, tt.created_at
FROM treatment_tags tt
JOIN treatments t ON tt.treatment_id = t.id
WHERE EXISTS (SELECT 1 FROM treatments WHERE treatments.id = tt.treatment_id);

DROP TABLE IF EXISTS treatment_tags;
ALTER TABLE treatment_tags_new RENAME TO treatment_tags;

CREATE INDEX IF NOT EXISTS idx_treatment_tags_subcategory ON treatment_tags(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_treatment_tags_tag ON treatment_tags(tag_id);

