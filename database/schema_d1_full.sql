-- ============================================
-- レディアンクリニック: 統合スキーマ（Cloudflare D1 / SQLite）
-- 目的: schema_d1.sql + content/campaigns/product_launches を統合
-- 追加: 記事コンテンツ拡張（articles）
-- ============================================

-- UUID代替: TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16))))
-- DATETIME: DEFAULT (datetime('now'))
-- BOOL: INTEGER 0/1

-- ============================================
-- マスターテーブル
-- ============================================

CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS subcategories (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(category_id, slug)
);

CREATE TABLE IF NOT EXISTS treatments (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(subcategory_id, slug)
);

-- ============================================
-- 料金プラン
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_plans (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
  plan_name TEXT NOT NULL,
  plan_type TEXT NOT NULL DEFAULT 'single'
    CHECK (plan_type IN ('single','course','trial','monitor','campaign')),
  sessions INTEGER,
  quantity TEXT,
  price INTEGER NOT NULL,
  price_taxed INTEGER NOT NULL,
  price_per_session INTEGER,
  price_per_session_taxed INTEGER,
  campaign_price INTEGER,
  campaign_price_taxed INTEGER,
  cost_rate REAL,
  campaign_cost_rate REAL,
  supply_cost INTEGER,
  staff_cost INTEGER,
  total_cost INTEGER,
  old_price INTEGER,
  staff_discount_rate INTEGER,
  notes TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- オプション・薬剤
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_options (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name TEXT NOT NULL,
  description TEXT,
  price INTEGER NOT NULL,
  price_taxed INTEGER NOT NULL,
  is_global INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS treatment_option_mappings (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
  option_id TEXT NOT NULL REFERENCES treatment_options(id) ON DELETE CASCADE,
  is_required INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(treatment_id, option_id)
);

CREATE TABLE IF NOT EXISTS medications (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  unit TEXT NOT NULL DEFAULT 'cc',
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS medication_plans (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  medication_id TEXT NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
  quantity TEXT NOT NULL,
  sessions INTEGER,
  price INTEGER NOT NULL,
  price_taxed INTEGER NOT NULL,
  campaign_price INTEGER,
  cost_rate REAL,
  supply_cost INTEGER,
  staff_cost INTEGER,
  total_cost INTEGER,
  staff_discount_rate INTEGER,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- 施術詳細コンテンツ
-- ============================================

CREATE TABLE IF NOT EXISTS treatment_details (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL UNIQUE REFERENCES treatments(id) ON DELETE CASCADE,
  tagline TEXT,
  tagline_en TEXT,
  summary TEXT,
  description TEXT,
  duration_min INTEGER,
  duration_max INTEGER,
  duration_text TEXT,
  downtime_days INTEGER DEFAULT 0,
  downtime_text TEXT,
  pain_level INTEGER CHECK (pain_level IS NULL OR pain_level BETWEEN 1 AND 5),
  effect_duration_months INTEGER,
  effect_duration_text TEXT,
  recommended_sessions INTEGER,
  session_interval_weeks INTEGER,
  session_interval_text TEXT,
  popularity_rank INTEGER,
  is_featured INTEGER NOT NULL DEFAULT 0,
  is_new INTEGER NOT NULL DEFAULT 0,
  hero_image_url TEXT,
  thumbnail_url TEXT,
  video_url TEXT,
  meta_title TEXT,
  meta_description TEXT,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS tags (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  tag_type TEXT NOT NULL CHECK (tag_type IN ('concern','effect','body_part','feature')),
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  icon TEXT,
  description TEXT,
  sort_order INTEGER DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(tag_type, slug)
);

CREATE TABLE IF NOT EXISTS treatment_tags (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
  tag_id TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  is_primary INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(treatment_id, tag_id)
);

CREATE TABLE IF NOT EXISTS treatment_flows (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
  step_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  duration_minutes INTEGER,
  icon TEXT,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(treatment_id, step_number)
);

CREATE TABLE IF NOT EXISTS treatment_cautions (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
  caution_type TEXT NOT NULL
    CHECK (caution_type IN ('contraindication','before','after','risk')),
  content TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

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

CREATE TABLE IF NOT EXISTS treatment_before_afters (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  treatment_id TEXT NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
  before_image_url TEXT NOT NULL,
  after_image_url TEXT NOT NULL,
  caption TEXT,
  patient_age INTEGER,
  patient_gender TEXT,
  treatment_count INTEGER,
  treatment_period TEXT,
  is_published INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER DEFAULT 0,
  treatment_content TEXT,
  treatment_duration TEXT,
  treatment_cost INTEGER,
  treatment_cost_text TEXT,
  risks TEXT,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- サービスコンテンツ（既存コンテンツ拡張）
-- ============================================

CREATE TABLE IF NOT EXISTS service_contents (
  id TEXT PRIMARY KEY,
  subcategory_id TEXT,
  name_ja TEXT NOT NULL,
  name_en TEXT,
  slug TEXT NOT NULL UNIQUE,
  source_url TEXT,
  about_subtitle TEXT,
  about_description TEXT,
  hero_image_url TEXT,
  is_published INTEGER NOT NULL DEFAULT 0,
  scraped_at TEXT,
  last_edited_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS service_features (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL REFERENCES service_contents(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  icon_url TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS service_recommendations (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL REFERENCES service_contents(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS service_overviews (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL UNIQUE REFERENCES service_contents(id) ON DELETE CASCADE,
  duration TEXT,
  downtime TEXT,
  frequency TEXT,
  makeup TEXT,
  bathing TEXT,
  contraindications TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS service_faqs (
  id TEXT PRIMARY KEY,
  service_content_id TEXT NOT NULL REFERENCES service_contents(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  answer TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

-- ============================================
-- キャンペーン
-- ============================================

CREATE TABLE IF NOT EXISTS campaigns (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  image_url TEXT,
  start_date DATE,
  end_date DATE,
  campaign_type TEXT DEFAULT 'discount',
  priority INTEGER DEFAULT 0,
  is_published INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS campaign_plans (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  campaign_id TEXT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  treatment_plan_id TEXT NOT NULL REFERENCES treatment_plans(id) ON DELETE CASCADE,
  discount_type TEXT NOT NULL DEFAULT 'percentage',
  discount_value INTEGER,
  special_price INTEGER,
  special_price_taxed INTEGER,
  min_sessions INTEGER,
  max_discount_amount INTEGER,
  display_name TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
  UNIQUE(campaign_id, treatment_plan_id)
);

-- ============================================
-- 新商品パイプライン（発売予定商品）
-- ============================================

CREATE TABLE IF NOT EXISTS product_launches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  description TEXT,
  target_category_id INTEGER,
  target_subcategory_name TEXT,
  status TEXT NOT NULL DEFAULT 'planning'
    CHECK(status IN ('planning','pricing','protocol','training','ready','launched','cancelled')),
  pricing_completed_at TEXT,
  protocol_completed_at TEXT,
  training_completed_at TEXT,
  launched_at TEXT,
  planned_price INTEGER,
  planned_price_taxed INTEGER,
  price_notes TEXT,
  protocol_document_url TEXT,
  protocol_notes TEXT,
  training_document_url TEXT,
  training_video_url TEXT,
  training_notes TEXT,
  web_registered_at TEXT,
  smaregi_registered_at TEXT,
  smaregi_product_code TEXT,
  medical_force_registered_at TEXT,
  medical_force_product_id TEXT,
  owner_name TEXT,
  subcategory_id INTEGER REFERENCES subcategories(id),
  priority INTEGER NOT NULL DEFAULT 0,
  target_launch_date TEXT,
  notes TEXT,
  is_new_subcategory INTEGER NOT NULL DEFAULT 1,
  existing_subcategory_id INTEGER REFERENCES subcategories(id),
  has_treatments INTEGER NOT NULL DEFAULT 0,
  treatment_variations TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS launch_tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
  task_type TEXT NOT NULL
    CHECK(task_type IN (
      'pricing','protocol','training_material','training_session','web_register',
      'smaregi_register','medical_force_register','photo_prepare','marketing','other'
    )),
  title TEXT NOT NULL,
  description TEXT,
  is_completed INTEGER NOT NULL DEFAULT 0,
  completed_at TEXT,
  completed_by TEXT,
  due_date TEXT,
  assignee TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS launch_plans (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
  plan_name TEXT NOT NULL,
  plan_type TEXT NOT NULL DEFAULT 'single'
    CHECK(plan_type IN ('single','course','trial','monitor','campaign')),
  sessions INTEGER DEFAULT 1,
  quantity TEXT,
  target_variation TEXT,
  price INTEGER NOT NULL,
  price_taxed INTEGER NOT NULL,
  price_per_session INTEGER,
  price_per_session_taxed INTEGER,
  supply_cost INTEGER DEFAULT 0,
  labor_cost INTEGER DEFAULT 0,
  total_cost INTEGER DEFAULT 0,
  cost_rate REAL,
  staff_discount_rate INTEGER,
  staff_price INTEGER,
  is_recommended INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS launch_monitors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
  patient_code TEXT,
  patient_age INTEGER,
  patient_gender TEXT CHECK(patient_gender IN ('male','female','other')),
  target_variation TEXT,
  sessions_planned INTEGER,
  sessions_completed INTEGER DEFAULT 0,
  first_treatment_date TEXT,
  last_treatment_date TEXT,
  next_treatment_date TEXT,
  monitor_price INTEGER,
  monitor_price_taxed INTEGER,
  consent_form_signed INTEGER NOT NULL DEFAULT 0,
  photo_consent INTEGER NOT NULL DEFAULT 0,
  can_use_for_web INTEGER NOT NULL DEFAULT 0,
  can_use_for_sns INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'scheduled'
    CHECK(status IN ('scheduled','in_progress','completed','cancelled')),
  satisfaction_score INTEGER CHECK(satisfaction_score BETWEEN 1 AND 5),
  doctor_notes TEXT,
  patient_feedback TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS launch_before_afters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  launch_id INTEGER NOT NULL REFERENCES product_launches(id) ON DELETE CASCADE,
  monitor_id INTEGER REFERENCES launch_monitors(id) ON DELETE SET NULL,
  before_image_key TEXT NOT NULL,
  after_image_key TEXT NOT NULL,
  before_image_url TEXT,
  after_image_url TEXT,
  target_variation TEXT,
  treatment_date TEXT,
  sessions_at_photo INTEGER,
  days_after_treatment INTEGER,
  patient_age INTEGER,
  patient_gender TEXT CHECK(patient_gender IN ('male','female','other')),
  title TEXT,
  description TEXT,
  doctor_comment TEXT,
  is_published INTEGER NOT NULL DEFAULT 0,
  is_featured INTEGER NOT NULL DEFAULT 0,
  can_use_for_web INTEGER NOT NULL DEFAULT 0,
  can_use_for_sns INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================
-- 記事コンテンツ（拡張スコープ）
-- ============================================

CREATE TABLE IF NOT EXISTS articles (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  excerpt TEXT,
  body TEXT,
  hero_image_url TEXT,
  author_name TEXT,
  is_published INTEGER NOT NULL DEFAULT 0,
  published_at DATETIME,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS article_blocks (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  article_id TEXT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  block_type TEXT NOT NULL
    CHECK (block_type IN ('text','image','quote','list','embed')),
  content TEXT,
  media_url TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS article_tags (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS article_tag_links (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  article_id TEXT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  tag_id TEXT NOT NULL REFERENCES article_tags(id) ON DELETE CASCADE,
  UNIQUE(article_id, tag_id)
);

-- ============================================
-- インデックス
-- ============================================

CREATE INDEX IF NOT EXISTS idx_subcategories_category ON subcategories(category_id);
CREATE INDEX IF NOT EXISTS idx_treatments_subcategory ON treatments(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_treatment ON treatment_plans(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_type ON treatment_plans(plan_type);
CREATE INDEX IF NOT EXISTS idx_medication_plans_medication ON medication_plans(medication_id);

CREATE INDEX IF NOT EXISTS idx_treatment_details_treatment ON treatment_details(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_tags_treatment ON treatment_tags(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_tags_tag ON treatment_tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_tags_type ON tags(tag_type);
CREATE INDEX IF NOT EXISTS idx_treatment_flows_treatment ON treatment_flows(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_cautions_treatment ON treatment_cautions(treatment_id);
CREATE INDEX IF NOT EXISTS idx_treatment_faqs_treatment ON treatment_faqs(treatment_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_treatment ON treatment_before_afters(treatment_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_published ON treatment_before_afters(is_published);

CREATE INDEX IF NOT EXISTS idx_service_contents_subcategory ON service_contents(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_service_contents_slug ON service_contents(slug);
CREATE INDEX IF NOT EXISTS idx_service_features_service ON service_features(service_content_id);
CREATE INDEX IF NOT EXISTS idx_service_recommendations_service ON service_recommendations(service_content_id);
CREATE INDEX IF NOT EXISTS idx_service_faqs_service ON service_faqs(service_content_id);

CREATE INDEX IF NOT EXISTS idx_campaigns_published ON campaigns(is_published);
CREATE INDEX IF NOT EXISTS idx_campaign_plans_campaign ON campaign_plans(campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_plans_plan ON campaign_plans(treatment_plan_id);

CREATE INDEX IF NOT EXISTS idx_product_launches_status ON product_launches(status);
CREATE INDEX IF NOT EXISTS idx_product_launches_target_date ON product_launches(target_launch_date);
CREATE INDEX IF NOT EXISTS idx_launch_tasks_launch ON launch_tasks(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_tasks_type ON launch_tasks(task_type);
CREATE INDEX IF NOT EXISTS idx_launch_tasks_completed ON launch_tasks(is_completed);
CREATE INDEX IF NOT EXISTS idx_launch_plans_launch ON launch_plans(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_plans_type ON launch_plans(plan_type);
CREATE INDEX IF NOT EXISTS idx_launch_monitors_launch ON launch_monitors(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_monitors_status ON launch_monitors(status);
CREATE INDEX IF NOT EXISTS idx_launch_before_afters_launch ON launch_before_afters(launch_id);
CREATE INDEX IF NOT EXISTS idx_launch_before_afters_monitor ON launch_before_afters(monitor_id);
CREATE INDEX IF NOT EXISTS idx_launch_before_afters_published ON launch_before_afters(is_published);

CREATE INDEX IF NOT EXISTS idx_article_blocks_article ON article_blocks(article_id);
CREATE INDEX IF NOT EXISTS idx_article_tags_slug ON article_tags(slug);

-- ============================================
-- 更新トリガー（必要なテーブルのみ）
-- ============================================

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
