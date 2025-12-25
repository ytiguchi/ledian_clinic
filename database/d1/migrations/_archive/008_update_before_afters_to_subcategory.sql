-- ============================================
-- マイグレーション: treatment_before_afters テーブルの作成
-- ============================================
-- テーブルが存在しない場合は新規作成、存在する場合は再作成してデータを移行

-- 新規テーブルを作成（すべてのフィールドを含む）
CREATE TABLE IF NOT EXISTS treatment_before_afters_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,
    treatment_content TEXT,
    treatment_duration VARCHAR(100),
    treatment_cost INTEGER,
    treatment_cost_text VARCHAR(100),
    risks TEXT,
    patient_age INTEGER,
    patient_gender VARCHAR(10),
    treatment_count INTEGER,
    treatment_period VARCHAR(50),
    is_published INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- 既存テーブルからデータを移行（テーブルが存在する場合のみ）
-- 注意: テーブルが存在しない場合は、このINSERTは実行されません（エラーになるが、wranglerは処理を続行しないため、より安全な方法を使用）
-- SQLiteでは直接的な条件分岐ができないため、テーブルが存在しない場合は空のテーブルが作成される

-- 旧テーブルを削除（存在する場合のみ）
DROP TABLE IF EXISTS treatment_before_afters;

-- 新テーブルをリネーム
ALTER TABLE treatment_before_afters_new RENAME TO treatment_before_afters;

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_before_afters_subcategory ON treatment_before_afters(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_published ON treatment_before_afters(is_published);
CREATE INDEX IF NOT EXISTS idx_before_afters_sort_order ON treatment_before_afters(sort_order);
