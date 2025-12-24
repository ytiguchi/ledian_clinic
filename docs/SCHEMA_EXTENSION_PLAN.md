# スキーマ拡張計画（詳細）

## 現状分析

### 実装済みテーブル

#### 基本構造（✅ 実装済み）
- `categories` - カテゴリ
- `subcategories` - サブカテゴリ
- `treatments` - 施術
- `treatment_plans` - 料金プラン

#### コンテンツ構造（一部実装）
- `treatment_details` - 施術詳細（定義はあるが未完全実装）
- `treatment_flows` - 施術フロー（定義済み）
- `treatment_cautions` - 注意事項（定義済み）
- `treatment_faqs` - FAQ（定義済み）
- `tags` - タグ（定義済み）
- `treatment_tags` - 施術-タグ関連（定義済み）

#### キャンペーン・マーケティング（✅ 実装済み）
- `campaigns` - キャンペーン
- `campaign_plans` - キャンペーンプラン

#### 症例（✅ 実装済み）
- `treatment_before_afters` - 症例写真

## 拡張が必要な項目

### 1. 施術詳細情報の完全実装

#### 1.1 `treatment_details` テーブルの拡張

**現状**: 基本的なフィールドは定義済み
**必要**: 以下の情報を追加

```sql
-- 既存の treatment_details に追加すべき項目
ALTER TABLE treatment_details ADD COLUMN IF NOT EXISTS hero_image_url VARCHAR(500);
ALTER TABLE treatment_details ADD COLUMN IF NOT EXISTS thumbnail_url VARCHAR(500);
ALTER TABLE treatment_details ADD COLUMN IF NOT EXISTS video_url VARCHAR(500);
ALTER TABLE treatment_details ADD COLUMN IF NOT EXISTS gallery_images JSONB; -- 複数画像
ALTER TABLE treatment_details ADD COLUMN IF NOT EXISTS specs JSONB; -- スペック情報（構造化）
ALTER TABLE treatment_details ADD COLUMN IF NOT EXISTS targets JSONB; -- ターゲット（お悩み・効果・部位）
```

#### 1.2 `treatment_flows` の実装

**現状**: テーブル定義はある
**必要**: フロントエンド実装とデータ投入

```sql
-- 既存定義を確認し、必要に応じて拡張
-- ステップ番号、タイトル、説明、所要時間、アイコンなど
```

#### 1.3 `treatment_cautions` の実装

**現状**: テーブル定義はある（caution_type ENUM）
**必要**: フロントエンド実装とデータ投入

```sql
-- 注意事項タイプ:
-- - contraindication (禁忌)
-- - before (施術前の注意)
-- - after (施術後の注意)
-- - risk (リスク・副作用)
```

#### 1.4 `treatment_faqs` の実装

**現状**: テーブル定義はある
**必要**: フロントエンド実装とデータ投入

### 2. メディア管理の正規化

#### 2.1 `media` テーブルの新規作成

```sql
CREATE TABLE media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type VARCHAR(20) NOT NULL, -- 'image', 'video', 'document'
    url VARCHAR(500) NOT NULL,
    thumbnail_url VARCHAR(500),
    alt_text VARCHAR(200),
    title VARCHAR(200),
    description TEXT,
    file_size INTEGER,
    mime_type VARCHAR(100),
    width INTEGER,
    height INTEGER,
    duration INTEGER, -- 動画の場合（秒）
    sort_order INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE treatment_media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    treatment_id UUID NOT NULL REFERENCES treatments(id) ON DELETE CASCADE,
    media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
    usage_type VARCHAR(50), -- 'hero', 'thumbnail', 'gallery', 'before_after', 'manual'
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(treatment_id, media_id, usage_type)
);
```

**利点**:
- メディアの再利用が可能
- メディア情報の一元管理
- 複数の施術で同じ画像を使用可能

### 3. タグシステムの実装

#### 3.1 `tags` テーブルの拡張

```sql
-- 既存の tags に追加
ALTER TABLE tags ADD COLUMN IF NOT EXISTS category VARCHAR(50); -- 'concern', 'effect', 'area', 'skin_type'
ALTER TABLE tags ADD COLUMN IF NOT EXISTS parent_id UUID REFERENCES tags(id); -- 階層構造
ALTER TABLE tags ADD COLUMN IF NOT EXISTS icon VARCHAR(10); -- 絵文字アイコン
ALTER TABLE tags ADD COLUMN IF NOT EXISTS color VARCHAR(20); -- 表示色
```

### 4. 価格履歴管理

#### 4.1 `price_history` テーブルの新規作成

```sql
CREATE TABLE price_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    treatment_plan_id UUID NOT NULL REFERENCES treatment_plans(id) ON DELETE CASCADE,
    price INTEGER NOT NULL,
    price_taxed INTEGER NOT NULL,
    campaign_price INTEGER,
    campaign_price_taxed INTEGER,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    changed_by VARCHAR(100), -- 変更者
    reason TEXT, -- 変更理由
    notes TEXT
);

CREATE INDEX idx_price_history_plan ON price_history(treatment_plan_id);
CREATE INDEX idx_price_history_date ON price_history(changed_at);
```

### 5. お知らせ・ニュース管理

#### 5.1 `announcements` テーブルの新規作成

```sql
CREATE TABLE announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    category VARCHAR(50), -- 'news', 'campaign', 'training', 'system'
    priority INTEGER DEFAULT 0, -- 0: 低, 1: 中, 2: 高
    target_audience VARCHAR(50), -- 'all', 'staff', 'admin'
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_announcements_published ON announcements(is_published, published_at);
CREATE INDEX idx_announcements_category ON announcements(category);
```

#### 5.2 `announcement_reads` テーブル（既読管理）

```sql
CREATE TABLE announcement_reads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    announcement_id UUID NOT NULL REFERENCES announcements(id) ON DELETE CASCADE,
    user_id VARCHAR(100) NOT NULL, -- Cloudflare Accessのメールアドレスなど
    read_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(announcement_id, user_id)
);
```

### 6. 一般FAQ管理

#### 6.1 `general_faqs` テーブルの新規作成

```sql
CREATE TABLE general_faqs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category VARCHAR(50), -- 'general', 'booking', 'payment', 'treatment'
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    view_count INTEGER DEFAULT 0,
    is_featured BOOLEAN DEFAULT false, -- よく見られるFAQ
    sort_order INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_general_faqs_category ON general_faqs(category, is_published);
CREATE INDEX idx_general_faqs_featured ON general_faqs(is_featured, is_published);
```

### 7. トレーニングマニュアル管理

#### 7.1 `training_manuals` テーブルの新規作成

```sql
CREATE TABLE training_manuals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    treatment_id UUID REFERENCES treatments(id) ON DELETE SET NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    file_url VARCHAR(500), -- PDF等のファイルURL
    video_url VARCHAR(500),
    category VARCHAR(50), -- 'procedure', 'explanation', 'safety'
    version VARCHAR(20),
    sort_order INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_training_manuals_treatment ON training_manuals(treatment_id);
CREATE INDEX idx_training_manuals_category ON training_manuals(category, is_published);
```

## 実装順序（推奨）

### Step 1: メディア管理の正規化
- 最も影響範囲が大きいため、最初に実装
- 既存の画像URLを`media`テーブルに移行

### Step 2: 施術詳細情報の完全実装
- `treatment_details`の拡張
- `treatment_flows`, `treatment_cautions`, `treatment_faqs`の実装

### Step 3: タグシステムの実装
- `tags`テーブルの拡張
- `treatment_tags`のデータ投入

### Step 4: 価格履歴管理
- 既存データの履歴化
- 新規価格変更時の履歴記録

### Step 5: トレーニング機能
- `announcements`, `general_faqs`, `training_manuals`の実装

## D1互換スキーマへの変換

PostgreSQLスキーマを拡張したら、D1用のマイグレーションファイルも作成する必要があります。

**変換ルール**:
- UUID → TEXT (hex)
- BOOLEAN → INTEGER (0/1)
- ENUM → TEXT with CHECK constraint
- TIMESTAMPTZ → DATETIME
- JSONB → TEXT (JSON文字列として保存)

## マイグレーション戦略

1. **新規テーブルの追加**: 既存データに影響なし
2. **既存テーブルの拡張**: ALTER TABLEで段階的に追加
3. **データ移行**: 既存データの移行スクリプトを作成
4. **バックアップ**: マイグレーション前に必ずバックアップ

## 関連ドキュメント

- [データ正規化ロードマップ](./DATA_NORMALIZATION_ROADMAP.md)
- [包括的ロードマップ](./COMPREHENSIVE_ROADMAP.md)
- [PostgreSQLスキーマ](../database/schema.sql)
- [D1マイグレーション](../database/d1/migrations/)



