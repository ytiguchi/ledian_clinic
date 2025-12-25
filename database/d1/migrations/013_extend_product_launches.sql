-- ============================================
-- 発売予定商品スキーマ拡張
-- - 複数料金プラン対応
-- - モニター管理
-- - 症例写真紐付け
-- - カテゴリ/サブカテゴリ精緻化
-- ============================================

-- ============================================
-- 1. product_launches テーブル拡張
-- ============================================

-- カテゴリ構造の精緻化
-- is_new_subcategory: 新規サブカテゴリとして作成するか、既存に追加するか
ALTER TABLE product_launches ADD COLUMN is_new_subcategory INTEGER NOT NULL DEFAULT 1;

-- 既存サブカテゴリに追加する場合のID
ALTER TABLE product_launches ADD COLUMN existing_subcategory_id INTEGER REFERENCES subcategories(id);

-- 施術階層（treatments）を作成するかどうか
-- 0: サブカテゴリのみ（ハイフなど単一施術）
-- 1: サブカテゴリ + treatments（ポテンツァのように複数バリエーション）
ALTER TABLE product_launches ADD COLUMN has_treatments INTEGER NOT NULL DEFAULT 0;

-- 施術バリエーション名（has_treatments=1の場合）
-- 例: "全顔,両頬,首" のようにカンマ区切り
ALTER TABLE product_launches ADD COLUMN treatment_variations TEXT;

-- 削除: 単一料金フィールド（複数プランに移行）
-- planned_price, planned_price_taxed は残すが、デフォルト料金として使用

-- ============================================
-- 2. 発売予定料金プラン（複数対応）
-- ============================================

CREATE TABLE IF NOT EXISTS launch_plans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
    
    -- プラン情報
    plan_name TEXT NOT NULL,                  -- "1回", "3回コース", "初回お試し"等
    plan_type TEXT NOT NULL DEFAULT 'single'  -- single, course, trial, monitor
        CHECK(plan_type IN ('single', 'course', 'trial', 'monitor', 'campaign')),
    sessions INTEGER DEFAULT 1,               -- 回数
    quantity TEXT,                            -- 数量表記（1cc, 10単位等）
    
    -- 対象施術バリエーション（NULLなら全バリエーション共通）
    target_variation TEXT,                    -- "全顔", "両頬" 等
    
    -- 価格情報
    price INTEGER NOT NULL,                   -- 税抜価格
    price_taxed INTEGER NOT NULL,             -- 税込価格
    price_per_session INTEGER,                -- 1回あたり税抜
    price_per_session_taxed INTEGER,          -- 1回あたり税込
    
    -- 原価情報
    supply_cost INTEGER DEFAULT 0,            -- 備品原価
    labor_cost INTEGER DEFAULT 0,             -- 人件費
    total_cost INTEGER DEFAULT 0,             -- 原価合計
    cost_rate REAL,                           -- 原価率（%）
    
    -- 社販価格
    staff_discount_rate INTEGER,              -- 社販OFF率（%）
    staff_price INTEGER,                      -- 社販価格
    
    -- メタ情報
    is_recommended INTEGER NOT NULL DEFAULT 0, -- おすすめプラン
    sort_order INTEGER NOT NULL DEFAULT 0,
    notes TEXT,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- 3. モニター管理
-- ============================================

CREATE TABLE IF NOT EXISTS launch_monitors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
    
    -- モニター情報
    patient_code TEXT,                        -- 患者コード（匿名化）
    patient_age INTEGER,
    patient_gender TEXT CHECK(patient_gender IN ('male', 'female', 'other')),
    
    -- 施術情報
    target_variation TEXT,                    -- 対象バリエーション
    sessions_planned INTEGER,                 -- 予定回数
    sessions_completed INTEGER DEFAULT 0,     -- 完了回数
    
    -- 日程
    first_treatment_date TEXT,                -- 初回施術日
    last_treatment_date TEXT,                 -- 最終施術日
    next_treatment_date TEXT,                 -- 次回予定日
    
    -- 価格（モニター価格）
    monitor_price INTEGER,
    monitor_price_taxed INTEGER,
    
    -- 同意・公開
    consent_form_signed INTEGER NOT NULL DEFAULT 0,  -- 同意書サイン済み
    photo_consent INTEGER NOT NULL DEFAULT 0,        -- 写真使用同意
    can_use_for_web INTEGER NOT NULL DEFAULT 0,      -- WEB使用可
    can_use_for_sns INTEGER NOT NULL DEFAULT 0,      -- SNS使用可
    
    -- ステータス
    status TEXT NOT NULL DEFAULT 'scheduled'
        CHECK(status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    
    -- 評価・備考
    satisfaction_score INTEGER CHECK(satisfaction_score BETWEEN 1 AND 5),
    doctor_notes TEXT,
    patient_feedback TEXT,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- 4. 発売予定症例写真
-- ============================================

CREATE TABLE IF NOT EXISTS launch_before_afters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
    monitor_id INTEGER REFERENCES launch_monitors(id) ON DELETE SET NULL,
    
    -- 画像（R2に保存）
    before_image_key TEXT NOT NULL,           -- R2キー
    after_image_key TEXT NOT NULL,            -- R2キー
    before_image_url TEXT,                    -- 署名付きURL（キャッシュ用）
    after_image_url TEXT,
    
    -- 施術情報
    target_variation TEXT,                    -- 対象バリエーション
    treatment_date TEXT,                      -- 施術日
    sessions_at_photo INTEGER,                -- 撮影時の施術回数
    days_after_treatment INTEGER,             -- 施術後何日目の写真か
    
    -- 患者情報（匿名化）
    patient_age INTEGER,
    patient_gender TEXT CHECK(patient_gender IN ('male', 'female', 'other')),
    
    -- 説明
    title TEXT,
    description TEXT,
    doctor_comment TEXT,
    
    -- 公開設定
    is_published INTEGER NOT NULL DEFAULT 0,
    is_featured INTEGER NOT NULL DEFAULT 0,   -- 注目症例
    can_use_for_web INTEGER NOT NULL DEFAULT 0,
    can_use_for_sns INTEGER NOT NULL DEFAULT 0,
    
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- 5. インデックス
-- ============================================

CREATE INDEX IF NOT EXISTS idx_launch_plans_launch ON launch_plans(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_plans_type ON launch_plans(plan_type);
CREATE INDEX IF NOT EXISTS idx_launch_monitors_launch ON launch_monitors(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_monitors_status ON launch_monitors(status);
CREATE INDEX IF NOT EXISTS idx_launch_before_afters_launch ON launch_before_afters(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_before_afters_monitor ON launch_before_afters(monitor_id);
CREATE INDEX IF NOT EXISTS idx_launch_before_afters_published ON launch_before_afters(is_published);

-- ============================================
-- 6. 更新トリガー
-- ============================================

CREATE TRIGGER IF NOT EXISTS trigger_launch_plans_updated_at
    AFTER UPDATE ON launch_plans
    FOR EACH ROW
BEGIN
    UPDATE launch_plans SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS trigger_launch_monitors_updated_at
    AFTER UPDATE ON launch_monitors
    FOR EACH ROW
BEGIN
    UPDATE launch_monitors SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS trigger_launch_before_afters_updated_at
    AFTER UPDATE ON launch_before_afters
    FOR EACH ROW
BEGIN
    UPDATE launch_before_afters SET updated_at = datetime('now') WHERE id = NEW.id;
END;

