-- カウンセリング資料テーブルの追加

-- カウンセリング資料
CREATE TABLE IF NOT EXISTS counseling_materials (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    file_url TEXT,                    -- R2バケットへのURLまたはキー
    file_type TEXT,                   -- 'pdf', 'docx', 'pptx', 'video', 'link'
    difficulty_level TEXT CHECK (difficulty_level IN ('basic', 'intermediate', 'advanced')),
    estimated_minutes INTEGER,
    is_published INTEGER NOT NULL DEFAULT 1,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_counseling_materials_subcategory ON counseling_materials(subcategory_id);

