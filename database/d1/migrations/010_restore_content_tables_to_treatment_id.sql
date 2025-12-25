-- ============================================
-- マイグレーション: content系テーブルを treatment_id ベースに戻す
-- ============================================
-- 4階層化(008)後に、施術単位のテーブルを subcategory_id から
-- treatment_id 参照へ戻す。
-- 前提: 008_restructure_to_4_tier.sql を適用済みで、
--       旧 subcategory_id が treatments.id と一致している。

-- ============================================
-- 1. treatment_details
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_details_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL UNIQUE REFERENCES treatments(id) ON DELETE CASCADE,
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

INSERT INTO treatment_details_new (
    id, treatment_id, tagline, tagline_en, summary, description,
    duration_min, duration_max, duration_text, downtime_days, downtime_text,
    pain_level, effect_duration_months, effect_duration_text,
    recommended_sessions, session_interval_weeks, session_interval_text,
    popularity_rank, is_featured, is_new, hero_image_url, thumbnail_url,
    video_url, meta_title, meta_description, created_at, updated_at
)
SELECT
    td.id,
    td.subcategory_id,
    td.tagline, td.tagline_en, td.summary, td.description,
    td.duration_min, td.duration_max, td.duration_text,
    td.downtime_days, td.downtime_text,
    td.pain_level, td.effect_duration_months, td.effect_duration_text,
    td.recommended_sessions, td.session_interval_weeks, td.session_interval_text,
    td.popularity_rank, td.is_featured, td.is_new,
    td.hero_image_url, td.thumbnail_url, td.video_url,
    td.meta_title, td.meta_description, td.created_at, td.updated_at
FROM treatment_details td
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = td.subcategory_id
);

DROP TABLE IF EXISTS treatment_details;
ALTER TABLE treatment_details_new RENAME TO treatment_details;
CREATE INDEX IF NOT EXISTS idx_treatment_details_treatment ON treatment_details(treatment_id);

-- ============================================
-- 2. treatment_flows
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_flows_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,
    title VARCHAR(50) NOT NULL,
    description TEXT,
    duration_minutes INTEGER,
    icon VARCHAR(10),
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(treatment_id, step_number)
);

INSERT INTO treatment_flows_new (
    id, treatment_id, step_number, title, description, duration_minutes, icon, created_at
)
SELECT
    tf.id,
    tf.subcategory_id,
    tf.step_number, tf.title, tf.description, tf.duration_minutes, tf.icon, tf.created_at
FROM treatment_flows tf
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = tf.subcategory_id
);

DROP TABLE IF EXISTS treatment_flows;
ALTER TABLE treatment_flows_new RENAME TO treatment_flows;
CREATE INDEX IF NOT EXISTS idx_treatment_flows_treatment ON treatment_flows(treatment_id);

-- ============================================
-- 3. treatment_cautions
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_cautions_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    caution_type VARCHAR(20) NOT NULL CHECK (caution_type IN ('contraindication', 'before', 'after', 'risk')),
    content TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO treatment_cautions_new (
    id, treatment_id, caution_type, content, sort_order, created_at
)
SELECT
    tc.id,
    tc.subcategory_id,
    tc.caution_type, tc.content, tc.sort_order, tc.created_at
FROM treatment_cautions tc
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = tc.subcategory_id
);

DROP TABLE IF EXISTS treatment_cautions;
ALTER TABLE treatment_cautions_new RENAME TO treatment_cautions;
CREATE INDEX IF NOT EXISTS idx_treatment_cautions_treatment ON treatment_cautions(treatment_id);

-- ============================================
-- 4. treatment_faqs
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_faqs_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_published INTEGER DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO treatment_faqs_new (
    id, treatment_id, question, answer, sort_order, is_published, created_at, updated_at
)
SELECT
    tfq.id,
    tfq.subcategory_id,
    tfq.question, tfq.answer, tfq.sort_order, tfq.is_published, tfq.created_at, tfq.updated_at
FROM treatment_faqs tfq
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = tfq.subcategory_id
);

DROP TABLE IF EXISTS treatment_faqs;
ALTER TABLE treatment_faqs_new RENAME TO treatment_faqs;
CREATE INDEX IF NOT EXISTS idx_treatment_faqs_treatment ON treatment_faqs(treatment_id);

-- ============================================
-- 5. treatment_tags
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_tags_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    is_primary INTEGER DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(treatment_id, tag_id)
);

INSERT INTO treatment_tags_new (
    id, treatment_id, tag_id, is_primary, sort_order, created_at
)
SELECT
    tt.id,
    tt.subcategory_id,
    tt.tag_id, tt.is_primary, tt.sort_order, tt.created_at
FROM treatment_tags tt
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = tt.subcategory_id
);

DROP TABLE IF EXISTS treatment_tags;
ALTER TABLE treatment_tags_new RENAME TO treatment_tags;
CREATE INDEX IF NOT EXISTS idx_treatment_tags_treatment ON treatment_tags(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_tags_tag ON treatment_tags(tag_id);

-- ============================================
-- 6. treatment_before_afters
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_before_afters_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,
    patient_age INTEGER,
    patient_gender VARCHAR(10),
    treatment_count INTEGER,
    treatment_period VARCHAR(50),
    is_published INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO treatment_before_afters_new (
    id, treatment_id, before_image_url, after_image_url, caption,
    patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order, created_at
)
SELECT
    tba.id,
    tba.subcategory_id,
    tba.before_image_url, tba.after_image_url, tba.caption,
    tba.patient_age, tba.patient_gender, tba.treatment_count, tba.treatment_period,
    tba.is_published, tba.sort_order, tba.created_at
FROM treatment_before_afters tba
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = tba.subcategory_id
);

DROP TABLE IF EXISTS treatment_before_afters;
ALTER TABLE treatment_before_afters_new RENAME TO treatment_before_afters;
CREATE INDEX IF NOT EXISTS idx_before_afters_treatment ON treatment_before_afters(treatment_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_published ON treatment_before_afters(is_published);

-- ============================================
-- 7. treatment_option_mappings
-- ============================================
CREATE TABLE IF NOT EXISTS treatment_option_mappings_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    option_id TEXT NOT NULL REFERENCES treatment_options(id) ON DELETE CASCADE,
    is_required INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(treatment_id, option_id)
);

INSERT INTO treatment_option_mappings_new (
    id, treatment_id, option_id, is_required, created_at
)
SELECT
    tom.id,
    tom.subcategory_id,
    tom.option_id, tom.is_required, tom.created_at
FROM treatment_option_mappings tom
WHERE EXISTS (
    SELECT 1 FROM treatments WHERE treatments.id = tom.subcategory_id
);

DROP TABLE IF EXISTS treatment_option_mappings;
ALTER TABLE treatment_option_mappings_new RENAME TO treatment_option_mappings;
CREATE INDEX IF NOT EXISTS idx_treatment_option_mappings_treatment ON treatment_option_mappings(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_option_mappings_option ON treatment_option_mappings(option_id);
