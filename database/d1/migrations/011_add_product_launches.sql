-- ============================================
-- 新商品パイプライン管理（発売予定商品）
-- ============================================

-- 商品ローンチ状態
-- planning: 企画中
-- pricing: 料金決定中
-- protocol: プロトコル策定中
-- training: 研修中
-- ready: 発売準備完了
-- launched: 発売済み
-- cancelled: 中止

-- 新商品パイプライン
CREATE TABLE IF NOT EXISTS product_launches (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    
    -- 基本情報
    name TEXT NOT NULL,                    -- 商品名（例: クマ取り、脂肪吸引注射）
    slug TEXT UNIQUE,                      -- URLスラッグ（発売後に設定）
    description TEXT,                      -- 商品説明
    
    -- カテゴリ（発売後にsubcategoriesに登録）
    target_category_id INTEGER,            -- 予定カテゴリ
    target_subcategory_name TEXT,          -- 予定サブカテゴリ名
    
    -- ステータス
    status TEXT NOT NULL DEFAULT 'planning' 
        CHECK(status IN ('planning', 'pricing', 'protocol', 'training', 'ready', 'launched', 'cancelled')),
    
    -- 各フェーズ完了日
    pricing_completed_at TEXT,             -- 料金決定日
    protocol_completed_at TEXT,            -- プロトコル決定日
    training_completed_at TEXT,            -- 研修完了日
    launched_at TEXT,                      -- 発売日
    
    -- 料金情報（決定後）
    planned_price INTEGER,                 -- 予定価格（税抜）
    planned_price_taxed INTEGER,           -- 予定価格（税込）
    price_notes TEXT,                      -- 料金備考
    
    -- プロトコル情報
    protocol_document_url TEXT,            -- プロトコル資料URL（R2）
    protocol_notes TEXT,                   -- プロトコル備考
    
    -- 研修情報
    training_document_url TEXT,            -- 研修資料URL（R2）
    training_video_url TEXT,               -- 研修動画URL
    training_notes TEXT,                   -- 研修備考
    
    -- 外部システム登録状況
    web_registered_at TEXT,                -- WEB登録日
    smaregi_registered_at TEXT,            -- スマレジ登録日
    smaregi_product_code TEXT,             -- スマレジ商品コード
    medical_force_registered_at TEXT,      -- メディカルフォース登録日
    medical_force_product_id TEXT,         -- メディカルフォースID
    
    -- 担当者
    owner_name TEXT,                       -- 主担当
    
    -- 発売後の紐付け
    subcategory_id INTEGER REFERENCES subcategories(id),  -- 発売後のサブカテゴリID
    
    -- メタ情報
    priority INTEGER NOT NULL DEFAULT 0,   -- 優先度（高いほど優先）
    target_launch_date TEXT,               -- 発売予定日
    notes TEXT,                            -- 備考
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ローンチタスク（チェックリスト）
CREATE TABLE IF NOT EXISTS launch_tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
    
    -- タスク情報
    task_type TEXT NOT NULL 
        CHECK(task_type IN (
            'pricing',           -- 料金決定
            'protocol',          -- プロトコル策定
            'training_material', -- 研修資料作成
            'training_session',  -- 研修実施
            'web_register',      -- WEB登録
            'smaregi_register',  -- スマレジ登録
            'medical_force_register', -- メディカルフォース登録
            'photo_prepare',     -- 写真準備
            'marketing',         -- マーケティング準備
            'other'              -- その他
        )),
    title TEXT NOT NULL,                   -- タスク名
    description TEXT,                      -- 詳細
    
    -- 状態
    is_completed INTEGER NOT NULL DEFAULT 0,
    completed_at TEXT,
    completed_by TEXT,                     -- 完了者
    
    -- 期限・担当
    due_date TEXT,
    assignee TEXT,
    
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_product_launches_status ON product_launches(status);
CREATE INDEX IF NOT EXISTS idx_product_launches_target_date ON product_launches(target_launch_date);
CREATE INDEX IF NOT EXISTS idx_launch_tasks_launch ON launch_tasks(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_tasks_type ON launch_tasks(task_type);
CREATE INDEX IF NOT EXISTS idx_launch_tasks_completed ON launch_tasks(is_completed);

-- 更新トリガー
CREATE TRIGGER IF NOT EXISTS trigger_product_launches_updated_at
    AFTER UPDATE ON product_launches
    FOR EACH ROW
BEGIN
    UPDATE product_launches SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS trigger_launch_tasks_updated_at
    AFTER UPDATE ON launch_tasks
    FOR EACH ROW
BEGIN
    UPDATE launch_tasks SET updated_at = datetime('now') WHERE id = NEW.id;
END;

