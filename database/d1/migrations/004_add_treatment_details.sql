-- ============================================
-- 施術詳細情報テーブル追加（Cloudflare D1 / SQLite互換）
-- ============================================

-- 施術の詳細情報（1施術につき1レコード）
CREATE TABLE IF NOT EXISTS treatment_details (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    
    -- 基本テキスト
    tagline VARCHAR(100),                    -- キャッチコピー「切らずにリフトアップ」
    tagline_en VARCHAR(100),                 -- 英語タグライン「Cut-free lifting」
    summary TEXT,                            -- 概要説明（300字以内）
    description TEXT,                        -- 詳細説明（Markdown対応）
    
    -- スペック情報
    duration_min INTEGER,                    -- 施術時間（分）最小
    duration_max INTEGER,                    -- 施術時間（分）最大
    duration_text VARCHAR(50),               -- 施術時間表示テキスト
    downtime_days INTEGER DEFAULT 0,         -- ダウンタイム（日数）
    downtime_text VARCHAR(50),               -- ダウンタイム表示テキスト
    pain_level INTEGER CHECK (pain_level IS NULL OR pain_level BETWEEN 1 AND 5), -- 痛みレベル1-5
    effect_duration_months INTEGER,          -- 効果持続期間（月）
    effect_duration_text VARCHAR(50),        -- 効果持続表示テキスト
    recommended_sessions INTEGER,            -- 推奨回数
    session_interval_weeks INTEGER,          -- 推奨間隔（週）
    session_interval_text VARCHAR(50),       -- 推奨間隔表示テキスト
    
    -- 人気・表示設定
    popularity_rank INTEGER,                 -- 人気ランキング（1=No.1）
    is_featured INTEGER NOT NULL DEFAULT 0,  -- 注目施術フラグ
    is_new INTEGER NOT NULL DEFAULT 0,       -- NEW表示フラグ
    
    -- メディア
    hero_image_url VARCHAR(500),             -- ヒーロー画像
    thumbnail_url VARCHAR(500),              -- サムネイル
    video_url VARCHAR(500),                  -- 動画URL（YouTube等）
    
    -- SEO
    meta_title VARCHAR(100),
    meta_description VARCHAR(200),
    
    -- メタ情報
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
    
    UNIQUE(treatment_id)
);

-- ============================================
-- タグマスター
-- ============================================

CREATE TABLE IF NOT EXISTS tags (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    tag_type TEXT NOT NULL CHECK (tag_type IN ('concern','effect','body_part','feature')),
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) NOT NULL,
    icon VARCHAR(10),                        -- 絵文字アイコン
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(tag_type, slug)
);

-- 施術×タグ紐付け
CREATE TABLE IF NOT EXISTS treatment_tags (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    is_primary INTEGER NOT NULL DEFAULT 0,   -- メインタグかどうか
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(treatment_id, tag_id)
);

-- ============================================
-- 施術フロー（施術の流れ）
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_flows (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,            -- ステップ番号
    title VARCHAR(50) NOT NULL,              -- ステップ名「カウンセリング」
    description TEXT,                        -- 説明文
    duration_minutes INTEGER,                -- 所要時間（分）
    icon VARCHAR(10),                        -- 絵文字アイコン
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    UNIQUE(treatment_id, step_number)
);

-- ============================================
-- 注意事項
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_cautions (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    caution_type TEXT NOT NULL CHECK (caution_type IN ('contraindication','before','after','risk')),
    content TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- よくある質問（FAQ）
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_faqs (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_published INTEGER NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- インデックス
-- ============================================

CREATE INDEX IF NOT EXISTS idx_treatment_details_treatment ON treatment_details(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_tags_treatment ON treatment_tags(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_tags_tag ON treatment_tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_tags_type ON tags(tag_type);
CREATE INDEX IF NOT EXISTS idx_treatment_flows_treatment ON treatment_flows(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_cautions_treatment ON treatment_cautions(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_faqs_treatment ON treatment_faqs(treatment_id);

