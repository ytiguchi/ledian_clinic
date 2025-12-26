-- 施術プロトコルテーブルの追加

-- 施術プロトコル（標準手順書）
-- counseling_materialsと同様にsubcategory_idベースで管理
CREATE TABLE IF NOT EXISTS treatment_protocols (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    version TEXT,
    file_url TEXT,                    -- R2バケットへのURLまたはキー
    file_type TEXT,                   -- 'pdf', 'docx', 'pptx', 'video', 'link'
    is_published INTEGER NOT NULL DEFAULT 1,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_treatment_protocols_subcategory ON treatment_protocols(subcategory_id);

