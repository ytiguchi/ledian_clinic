-- ============================================
-- サービスコンテンツ管理スキーマ
-- WEBからスクレイピングした商品説明を構造化
-- ============================================

-- ============================================
-- 1. サービス詳細コンテンツ (メインテーブル)
-- ============================================
CREATE TABLE IF NOT EXISTS service_contents (
    id TEXT PRIMARY KEY,
    subcategory_id TEXT,                    -- subcategoriesテーブルへの外部キー (後で紐付け可能)
    
    -- 基本情報
    name_ja TEXT NOT NULL,                  -- 日本語名 (例: ポテンツァ)
    name_en TEXT,                           -- 英語名 (例: POTENZA)
    slug TEXT NOT NULL UNIQUE,              -- URLスラッグ (例: potenza)
    source_url TEXT,                        -- スクレイピング元URL
    
    -- ABOUT セクション
    about_subtitle TEXT,                    -- サブタイトル (例: 〜最先端マイクロニードルRF治療〜)
    about_description TEXT,                 -- 概要説明
    
    -- メタ情報
    hero_image_url TEXT,                    -- ヒーロー画像URL
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    scraped_at TEXT,                        -- スクレイピング日時
    last_edited_at TEXT,                    -- 最終編集日時
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE
);

-- ============================================
-- 2. 特徴・こだわり (FEATURES)
-- ============================================
CREATE TABLE IF NOT EXISTS service_features (
    id TEXT PRIMARY KEY,
    service_content_id TEXT NOT NULL,
    
    title TEXT NOT NULL,                    -- 特徴タイトル
    description TEXT,                       -- 説明文
    icon_url TEXT,                          -- アイコン画像
    sort_order INTEGER NOT NULL DEFAULT 0,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

-- ============================================
-- 3. おすすめの方・適応症状 (RECOMMEND)
-- ============================================
CREATE TABLE IF NOT EXISTS service_recommendations (
    id TEXT PRIMARY KEY,
    service_content_id TEXT NOT NULL,
    
    text TEXT NOT NULL,                     -- 推奨テキスト (例: 毛穴を引き締めたい)
    sort_order INTEGER NOT NULL DEFAULT 0,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

-- ============================================
-- 4. 施術概要 (OVERVIEW)
-- ============================================
CREATE TABLE IF NOT EXISTS service_overviews (
    id TEXT PRIMARY KEY,
    service_content_id TEXT NOT NULL UNIQUE,
    
    duration TEXT,                          -- 施術時間 (例: 60分程度)
    downtime TEXT,                          -- ダウンタイム
    frequency TEXT,                         -- 施術頻度
    makeup TEXT,                            -- メイク可能時期
    bathing TEXT,                           -- 入浴制限
    contraindications TEXT,                 -- 禁忌事項
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

-- ============================================
-- 5. FAQ (よくある質問)
-- ============================================
CREATE TABLE IF NOT EXISTS service_faqs (
    id TEXT PRIMARY KEY,
    service_content_id TEXT NOT NULL,
    
    question TEXT NOT NULL,                 -- 質問
    answer TEXT,                            -- 回答
    sort_order INTEGER NOT NULL DEFAULT 0,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (service_content_id) REFERENCES service_contents(id) ON DELETE CASCADE
);

-- ============================================
-- 6. 症例写真 (CASES) - before_aftersテーブルを拡張
-- ============================================
-- before_aftersテーブルは010_new_schema.sqlで定義済み
-- 追加でスクレイピングしたデータ用のカラムを追加

-- ============================================
-- インデックス
-- ============================================
CREATE INDEX IF NOT EXISTS idx_service_contents_subcategory ON service_contents(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_service_contents_slug ON service_contents(slug);
CREATE INDEX IF NOT EXISTS idx_service_features_service ON service_features(service_content_id);
CREATE INDEX IF NOT EXISTS idx_service_recommendations_service ON service_recommendations(service_content_id);
CREATE INDEX IF NOT EXISTS idx_service_faqs_service ON service_faqs(service_content_id);

