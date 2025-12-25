-- ============================================
-- レディアンクリニック 新スキーマ設計
-- 4階層構造 + 症例写真・研修・プロトコル管理
-- Updated: 2024-12-24
-- ============================================

-- 既存ビューを削除
DROP VIEW IF EXISTS v_price_list;
DROP VIEW IF EXISTS v_campaign_prices;
DROP VIEW IF EXISTS v_treatments_full;

-- 既存テーブルを削除（依存関係順）
DROP TABLE IF EXISTS campaign_items;
DROP TABLE IF EXISTS training_records;
DROP TABLE IF EXISTS training_materials;
DROP TABLE IF EXISTS trainings;
DROP TABLE IF EXISTS protocols;
DROP TABLE IF EXISTS before_afters;
DROP TABLE IF EXISTS treatment_tags;
DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS treatment_plans;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS media;

-- ============================================
-- マスターテーブル
-- ============================================

-- スタッフマスター
CREATE TABLE staff (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    name_kana TEXT,
    role TEXT NOT NULL DEFAULT 'nurse', -- doctor, nurse, receptionist, trainer, admin
    email TEXT,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- メディアファイル管理
CREATE TABLE media (
    id TEXT PRIMARY KEY,
    filename TEXT NOT NULL,
    original_filename TEXT,
    mime_type TEXT NOT NULL,
    size INTEGER,
    url TEXT NOT NULL,
    thumbnail_url TEXT,
    alt_text TEXT,
    uploaded_by TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (uploaded_by) REFERENCES staff(id)
);

-- タグマスター（効果、お悩み、部位など）
CREATE TABLE tags (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    tag_type TEXT NOT NULL DEFAULT 'effect', -- effect(効果), concern(お悩み), area(部位), feature(特徴)
    description TEXT,
    color TEXT, -- UIでの表示色
    icon TEXT,  -- アイコン名
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- 4階層構造（メイン）
-- ============================================

-- 1. 大カテゴリ（肌診断、リフトアップ、ニキビ治療など）
CREATE TABLE categories (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    color TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    is_public INTEGER NOT NULL DEFAULT 1, -- 公開サイトに表示するか
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- 2. 中カテゴリ/治療法（ハイフ、ポテンツァ、ピコレーザーなど）
CREATE TABLE subcategories (
    id TEXT PRIMARY KEY,
    category_id TEXT NOT NULL,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,
    short_description TEXT, -- 一覧表示用の短い説明
    thumbnail_id TEXT,      -- サムネイル画像
    
    -- 機器/薬剤情報
    device_name TEXT,       -- 使用機器名
    manufacturer TEXT,      -- メーカー
    
    -- 施術情報
    duration_minutes INTEGER,    -- 施術時間（分）
    downtime TEXT,               -- ダウンタイム
    pain_level INTEGER,          -- 痛みレベル (1-5)
    recommended_frequency TEXT,  -- 推奨頻度
    
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    is_public INTEGER NOT NULL DEFAULT 1,
    is_popular INTEGER NOT NULL DEFAULT 0, -- 人気メニュー
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (thumbnail_id) REFERENCES media(id),
    UNIQUE(category_id, slug)
);

-- 3. 施術/部位バリエーション（全顔、両頬、S25チップなど）
CREATE TABLE treatments (
    id TEXT PRIMARY KEY,
    subcategory_id TEXT NOT NULL,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,
    
    -- 部位/バリエーション情報
    target_area TEXT,        -- 施術部位
    variation_type TEXT,     -- バリエーションタイプ（部位、チップ種類、薬剤など）
    
    -- 施術詳細
    duration_minutes INTEGER,    -- この施術の所要時間
    
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    is_public INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE,
    UNIQUE(subcategory_id, slug)
);

-- 4. 料金プラン
CREATE TABLE treatment_plans (
    id TEXT PRIMARY KEY,
    treatment_id TEXT NOT NULL,
    
    -- プラン情報
    plan_name TEXT NOT NULL,       -- 1回、3回コース、初回お試し等
    plan_type TEXT NOT NULL DEFAULT 'single', -- single, course, trial, monitor, campaign
    sessions INTEGER DEFAULT 1,    -- 回数
    quantity TEXT,                 -- 数量表記（1cc、10本、30錠など）
    
    -- 価格情報
    price INTEGER NOT NULL,           -- 税抜価格
    price_taxed INTEGER NOT NULL,     -- 税込価格
    price_per_session INTEGER,        -- 1回あたり税抜
    price_per_session_taxed INTEGER,  -- 1回あたり税込
    
    -- 原価情報
    supply_cost INTEGER DEFAULT 0,    -- 備品原価
    labor_cost INTEGER DEFAULT 0,     -- 医師・看護師原価
    total_cost INTEGER DEFAULT 0,     -- 原価合計
    cost_rate REAL,                   -- 原価率
    
    -- 社販価格
    staff_discount_rate INTEGER,      -- 社販OFF率（60%など）
    staff_price INTEGER,              -- 社販価格
    
    -- 旧価格（参考）
    old_price INTEGER,
    old_price_taxed INTEGER,
    
    -- 表示設定
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active INTEGER NOT NULL DEFAULT 1,
    is_public INTEGER NOT NULL DEFAULT 1,
    is_recommended INTEGER NOT NULL DEFAULT 0, -- おすすめプラン
    
    -- 備考
    notes TEXT,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE
);

-- ============================================
-- キャンペーン管理
-- ============================================

CREATE TABLE campaigns (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    
    -- 期間
    start_date TEXT,
    end_date TEXT,
    
    -- 表示設定
    banner_image_id TEXT,
    is_published INTEGER NOT NULL DEFAULT 0,
    is_featured INTEGER NOT NULL DEFAULT 0, -- トップページ表示
    
    -- 割引設定
    discount_type TEXT DEFAULT 'fixed', -- fixed(固定額), percent(割合)
    discount_value INTEGER,              -- 割引額または割引率
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (banner_image_id) REFERENCES media(id)
);

-- キャンペーン対象アイテム
CREATE TABLE campaign_items (
    id TEXT PRIMARY KEY,
    campaign_id TEXT NOT NULL,
    
    -- 対象（いずれか1つ）
    treatment_plan_id TEXT,
    treatment_id TEXT,
    subcategory_id TEXT,
    
    -- キャンペーン価格（個別設定）
    campaign_price INTEGER,
    campaign_price_taxed INTEGER,
    campaign_cost_rate REAL,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_plan_id) REFERENCES treatment_plans(id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE,
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE
);

-- ============================================
-- 症例写真（ビフォーアフター）
-- ============================================

CREATE TABLE before_afters (
    id TEXT PRIMARY KEY,
    
    -- 紐付け（いずれか1つ以上）
    subcategory_id TEXT,
    treatment_id TEXT,
    treatment_plan_id TEXT,
    
    -- 患者情報（匿名化）
    patient_age INTEGER,
    patient_gender TEXT,  -- male, female, other
    
    -- 画像
    before_image_id TEXT NOT NULL,
    after_image_id TEXT NOT NULL,
    
    -- 施術情報
    treatment_date TEXT,
    sessions_completed INTEGER,
    total_sessions INTEGER,
    
    -- 説明
    title TEXT,
    description TEXT,
    doctor_comment TEXT,
    
    -- 公開設定
    is_published INTEGER NOT NULL DEFAULT 0,
    is_featured INTEGER NOT NULL DEFAULT 0,
    consent_obtained INTEGER NOT NULL DEFAULT 1, -- 同意取得済み
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    created_by TEXT,
    
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE SET NULL,
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE SET NULL,
    FOREIGN KEY (treatment_plan_id) REFERENCES treatment_plans(id) ON DELETE SET NULL,
    FOREIGN KEY (before_image_id) REFERENCES media(id),
    FOREIGN KEY (after_image_id) REFERENCES media(id),
    FOREIGN KEY (created_by) REFERENCES staff(id)
);

-- ============================================
-- 施術プロトコル
-- ============================================

CREATE TABLE protocols (
    id TEXT PRIMARY KEY,
    
    -- 紐付け（いずれか1つ）
    subcategory_id TEXT,
    treatment_id TEXT,
    
    -- プロトコル情報
    title TEXT NOT NULL,
    version TEXT DEFAULT '1.0',
    
    -- 内容
    overview TEXT,           -- 概要
    indications TEXT,        -- 適応症
    contraindications TEXT,  -- 禁忌
    preparation TEXT,        -- 準備
    procedure_steps TEXT,    -- 手順（JSON形式で複数ステップ）
    aftercare TEXT,          -- アフターケア
    complications TEXT,      -- 合併症・対処法
    
    -- 所要時間
    prep_time_minutes INTEGER,
    procedure_time_minutes INTEGER,
    total_time_minutes INTEGER,
    
    -- 必要物品
    required_equipment TEXT, -- JSON形式
    required_consumables TEXT, -- JSON形式
    
    -- 公開設定
    is_published INTEGER NOT NULL DEFAULT 0,
    is_latest INTEGER NOT NULL DEFAULT 1, -- 最新バージョン
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    created_by TEXT,
    approved_by TEXT,
    approved_at TEXT,
    
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES staff(id),
    FOREIGN KEY (approved_by) REFERENCES staff(id)
);

-- ============================================
-- 研修管理
-- ============================================

CREATE TABLE trainings (
    id TEXT PRIMARY KEY,
    
    -- 紐付け（いずれか1つ）
    subcategory_id TEXT,
    treatment_id TEXT,
    
    -- 研修情報
    title TEXT NOT NULL,
    description TEXT,
    training_type TEXT DEFAULT 'practical', -- practical(実技), lecture(座学), online(オンライン), certification(認定)
    
    -- 対象
    target_roles TEXT, -- JSON配列 ['doctor', 'nurse']
    difficulty_level INTEGER DEFAULT 1, -- 1-5
    
    -- 時間
    duration_minutes INTEGER,
    
    -- 必須/任意
    is_required INTEGER NOT NULL DEFAULT 0,
    prerequisite_training_id TEXT, -- 前提となる研修
    
    -- 公開設定
    is_active INTEGER NOT NULL DEFAULT 1,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE,
    FOREIGN KEY (prerequisite_training_id) REFERENCES trainings(id)
);

-- 研修資料
CREATE TABLE training_materials (
    id TEXT PRIMARY KEY,
    training_id TEXT NOT NULL,
    
    title TEXT NOT NULL,
    material_type TEXT DEFAULT 'document', -- document, video, quiz, checklist
    
    -- コンテンツ
    content TEXT,        -- テキストコンテンツまたはURL
    media_id TEXT,       -- 添付ファイル
    
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_required INTEGER NOT NULL DEFAULT 1,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (training_id) REFERENCES trainings(id) ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- 研修受講記録
CREATE TABLE training_records (
    id TEXT PRIMARY KEY,
    training_id TEXT NOT NULL,
    staff_id TEXT NOT NULL,
    
    -- 受講状況
    status TEXT DEFAULT 'not_started', -- not_started, in_progress, completed, expired
    started_at TEXT,
    completed_at TEXT,
    
    -- 評価
    score INTEGER,           -- テストスコア
    passed INTEGER,          -- 合格/不合格
    instructor_id TEXT,      -- 講師
    instructor_comment TEXT, -- 講師コメント
    
    -- 有効期限
    expires_at TEXT,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (training_id) REFERENCES trainings(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES staff(id),
    
    UNIQUE(training_id, staff_id)
);

-- ============================================
-- タグ紐付け
-- ============================================

CREATE TABLE treatment_tags (
    id TEXT PRIMARY KEY,
    
    -- 紐付け対象（いずれか1つ）
    subcategory_id TEXT,
    treatment_id TEXT,
    
    tag_id TEXT NOT NULL,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- ============================================
-- 汎用備考/注意事項
-- ============================================

CREATE TABLE notes (
    id TEXT PRIMARY KEY,
    
    -- 紐付け対象
    entity_type TEXT NOT NULL, -- category, subcategory, treatment, treatment_plan
    entity_id TEXT NOT NULL,
    
    -- 内容
    note_type TEXT DEFAULT 'info', -- info, warning, important, internal
    title TEXT,
    content TEXT NOT NULL,
    
    -- 表示設定
    is_public INTEGER NOT NULL DEFAULT 0, -- 公開サイトに表示
    sort_order INTEGER NOT NULL DEFAULT 0,
    
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- インデックス
-- ============================================

CREATE INDEX idx_subcategories_category ON subcategories(category_id);
CREATE INDEX idx_treatments_subcategory ON treatments(subcategory_id);
CREATE INDEX idx_treatment_plans_treatment ON treatment_plans(treatment_id);
CREATE INDEX idx_campaign_items_campaign ON campaign_items(campaign_id);
CREATE INDEX idx_before_afters_subcategory ON before_afters(subcategory_id);
CREATE INDEX idx_before_afters_treatment ON before_afters(treatment_id);
CREATE INDEX idx_protocols_subcategory ON protocols(subcategory_id);
CREATE INDEX idx_protocols_treatment ON protocols(treatment_id);
CREATE INDEX idx_trainings_subcategory ON trainings(subcategory_id);
CREATE INDEX idx_trainings_treatment ON trainings(treatment_id);
CREATE INDEX idx_training_records_staff ON training_records(staff_id);
CREATE INDEX idx_treatment_tags_tag ON treatment_tags(tag_id);
CREATE INDEX idx_notes_entity ON notes(entity_type, entity_id);

-- ============================================
-- ビュー
-- ============================================

-- 料金表ビュー（4階層結合）
CREATE VIEW v_price_list AS
SELECT 
    c.id AS category_id,
    c.name AS category_name,
    c.slug AS category_slug,
    c.sort_order AS category_sort,
    
    sc.id AS subcategory_id,
    sc.name AS subcategory_name,
    sc.slug AS subcategory_slug,
    sc.device_name,
    sc.sort_order AS subcategory_sort,
    
    t.id AS treatment_id,
    t.name AS treatment_name,
    t.slug AS treatment_slug,
    t.target_area,
    t.sort_order AS treatment_sort,
    
    tp.id AS plan_id,
    tp.plan_name,
    tp.plan_type,
    tp.sessions,
    tp.quantity,
    tp.price,
    tp.price_taxed,
    tp.price_per_session,
    tp.price_per_session_taxed,
    tp.supply_cost,
    tp.labor_cost,
    tp.total_cost,
    tp.cost_rate,
    tp.staff_discount_rate,
    tp.staff_price,
    tp.is_recommended,
    tp.notes,
    tp.sort_order AS plan_sort
    
FROM categories c
JOIN subcategories sc ON c.id = sc.category_id
JOIN treatments t ON sc.id = t.subcategory_id
JOIN treatment_plans tp ON t.id = tp.treatment_id
WHERE c.is_active = 1 
  AND sc.is_active = 1 
  AND t.is_active = 1 
  AND tp.is_active = 1
ORDER BY 
    c.sort_order, 
    sc.sort_order, 
    t.sort_order, 
    tp.sort_order;

-- キャンペーン料金ビュー
CREATE VIEW v_campaign_prices AS
SELECT 
    camp.id AS campaign_id,
    camp.title AS campaign_title,
    camp.start_date,
    camp.end_date,
    ci.campaign_price,
    ci.campaign_price_taxed,
    ci.campaign_cost_rate,
    tp.id AS plan_id,
    tp.plan_name,
    tp.price AS original_price,
    tp.price_taxed AS original_price_taxed,
    t.name AS treatment_name,
    sc.name AS subcategory_name,
    c.name AS category_name
FROM campaigns camp
JOIN campaign_items ci ON camp.id = ci.campaign_id
LEFT JOIN treatment_plans tp ON ci.treatment_plan_id = tp.id
LEFT JOIN treatments t ON tp.treatment_id = t.id OR ci.treatment_id = t.id
LEFT JOIN subcategories sc ON t.subcategory_id = sc.id OR ci.subcategory_id = sc.id
LEFT JOIN categories c ON sc.category_id = c.id
WHERE camp.is_published = 1;

