-- 症例写真（ビフォーアフター）テーブル追加（D1用）
-- PostgreSQL版: schema_content.sql の treatment_before_afters をD1互換に変換

CREATE TABLE IF NOT EXISTS treatment_before_afters (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,
    patient_age INTEGER,
    patient_gender VARCHAR(10),
    treatment_count INTEGER,
    treatment_period VARCHAR(50),
    is_published INTEGER NOT NULL DEFAULT 0,  -- BOOLEAN → INTEGER (0/1)
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_before_afters_treatment ON treatment_before_afters(treatment_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_published ON treatment_before_afters(is_published);

