# キャンペーン管理スキーマ設計

## 📋 概要

キャンペーン期間中のみ価格を適用し、期間外は通常価格を表示する仕組みです。

## 🗂️ テーブル構成

### 1. `campaigns` - キャンペーンマスター

| カラム | 型 | 説明 |
|--------|-----|------|
| `id` | UUID | プライマリキー |
| `title` | VARCHAR(100) | キャンペーン名「Holiday Campaign」 |
| `slug` | VARCHAR(100) | スラッグ（URL用） |
| `description` | TEXT | 説明文 |
| `campaign_type` | VARCHAR(20) | 種別（discount/bundle/point/referral） |
| `start_date` | DATE | 開始日（NULLは無期限開始） |
| `end_date` | DATE | 終了日（NULLは無期限） |
| `is_published` | BOOLEAN | 公開フラグ |
| `priority` | INTEGER | 優先度（複数適用時） |
| `sort_order` | INTEGER | 表示順 |

### 2. `campaign_plans` - キャンペーン×プラン紐付け

| カラム | 型 | 説明 |
|--------|-----|------|
| `id` | UUID | プライマリキー |
| `campaign_id` | UUID | キャンペーンID（外部キー） |
| `treatment_plan_id` | UUID | プランID（外部キー） |
| `discount_type` | VARCHAR(20) | 割引タイプ |
| `discount_value` | INTEGER | 割引率(%) または 固定額(円) |
| `special_price` | INTEGER | 特別価格（税抜） |
| `special_price_taxed` | INTEGER | 特別価格（税込） |

**割引タイプの例:**
- `percentage`: 20%OFF → `discount_value = 20`
- `fixed`: 5,000円OFF → `discount_value = 5000`
- `special_price`: 特別価格 → `special_price`を使用

### 3. `treatment_plans` - プラン（既存）

キャンペーン適用時は自動更新される（`sync_campaign_prices()`関数使用）:

- `campaign_id`: 適用中のキャンペーンID
- `campaign_price`: キャンペーン価格（税抜）
- `campaign_price_taxed`: キャンペーン価格（税込）

## 🔄 データフロー

```
1. campaigns テーブルにキャンペーン情報を登録
   ↓
2. campaign_plans テーブルにプラン×割引設定を登録
   ↓
3. sync_campaign_prices() を実行
   ↓
4. treatment_plans の campaign_price/campaign_id が更新
   ↓
5. フロントエンドでキャンペーン価格を表示
```

## 📝 使用例

### キャンペーン作成

```sql
-- 1. キャンペーン登録
INSERT INTO campaigns (id, title, slug, start_date, end_date, is_published)
VALUES (
    'campaign-holiday-2024'::UUID,
    'Holiday Campaign',
    'holiday-2024',
    '2024-12-10',
    '2025-01-31',
    true
);

-- 2. プランに適用
INSERT INTO campaign_plans (campaign_id, treatment_plan_id, discount_type, discount_value)
SELECT 
    'campaign-holiday-2024'::UUID,
    tp.id,
    'percentage',
    20  -- 20%OFF
FROM treatment_plans tp
JOIN treatments t ON tp.treatment_id = t.id
WHERE t.name LIKE '%オンダリフト%'
  AND tp.plan_name = '1回';

-- 3. 価格を同期
SELECT sync_campaign_prices();
```

### キャンペーン価格取得

```sql
-- 特定プランのキャンペーン価格を取得
SELECT * FROM calculate_campaign_price('プランID'::UUID);

-- 現在適用中の全キャンペーン
SELECT * FROM v_active_campaign_plans;
```

### 期間外の処理

- `end_date`が過ぎたキャンペーンは自動的に`v_active_campaign_plans`から除外
- `sync_campaign_prices()`実行時、期間外のプランは`campaign_price = NULL`に戻る

## ⚙️ 定期実行（推奨）

キャンペーン価格を自動同期するため、定期実行を推奨:

```sql
-- 毎日実行（cron等で設定）
SELECT sync_campaign_prices();
```

または、PostgreSQLの`pg_cron`拡張を使用:

```sql
SELECT cron.schedule('sync-campaign-prices', '0 0 * * *', 'SELECT sync_campaign_prices()');
```

## 🎯 メリット

1. **期間管理**: `start_date`/`end_date`で自動的に適用期間を管理
2. **柔軟な割引**: パーセント・固定額・特別価格に対応
3. **優先度**: 複数キャンペーン適用時も優先度で自動選択
4. **自動同期**: `sync_campaign_prices()`で`treatment_plans`を自動更新
5. **プラン単位**: プランごとに個別設定可能

