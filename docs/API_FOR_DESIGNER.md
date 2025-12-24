# デザイナー向けAPI仕様書

## 概要

本番サイト構築用のAPI仕様です。内部サイトで管理されたデータをAPI経由で取得できます。

## ベースURL

```
https://internal.ledian-clinic.com/api/v1
```

（本番環境のURLは要確認）

## 認証

### API Key認証（推奨）

```
Authorization: Bearer {API_KEY}
```

### または、Cloudflare Access経由

内部サイトと同じ認証方式を使用（デザイナーにAccess設定を提供）

## エンドポイント一覧

### 1. カテゴリ一覧

```
GET /categories
```

**レスポンス例:**
```json
{
  "categories": [
    {
      "id": "uuid",
      "name": "スキンケア",
      "slug": "skincare",
      "sort_order": 1,
      "is_active": true
    }
  ]
}
```

### 2. サブカテゴリ一覧

```
GET /subcategories?category_id={category_id}
```

**クエリパラメータ:**
- `category_id` (required): カテゴリID

### 3. 施術一覧

```
GET /treatments?subcategory_id={subcategory_id}
```

**クエリパラメータ:**
- `subcategory_id` (required): サブカテゴリID

### 4. 料金プラン一覧

```
GET /plans?treatment_id={treatment_id}
GET /plans?category_id={category_id}
GET /plans?search={keyword}
```

**クエリパラメータ:**
- `treatment_id` (optional): 施術ID
- `category_id` (optional): カテゴリID
- `search` (optional): 検索キーワード

**レスポンス例:**
```json
{
  "plans": [
    {
      "id": "uuid",
      "treatment_id": "uuid",
      "treatment_name": "ウルトラセルZi",
      "plan_name": "1回",
      "plan_type": "single",
      "sessions": 1,
      "price": 50000,
      "price_taxed": 55000,
      "campaign_price": 45000,
      "campaign_price_taxed": 49500,
      "category_name": "スキンケア",
      "subcategory_name": "ハイフ"
    }
  ]
}
```

### 5. 施術詳細

```
GET /treatments/{treatment_id}
```

**レスポンス例:**
```json
{
  "treatment": {
    "id": "uuid",
    "name": "ウルトラセルZi",
    "slug": "ultracel-zi",
    "description": "高密度集束超音波治療",
    "category": {
      "id": "uuid",
      "name": "スキンケア"
    },
    "subcategory": {
      "id": "uuid",
      "name": "ハイフ"
    },
    "details": {
      "specs": {},
      "targets": [],
      "faqs": [],
      "cautions": []
    }
  }
}
```

### 6. キャンペーン一覧

```
GET /campaigns?is_active=true
```

### 7. 症例写真

```
GET /before-afters?treatment_id={treatment_id}
```

## データ構造

### PostgreSQLスキーマ

内部サイト（D1）のデータ構造と同等のPostgreSQLスキーマを提供します。

**主要テーブル:**
- `categories`
- `subcategories`
- `treatments`
- `treatment_plans`
- `campaigns`
- `treatment_before_afters`

詳細は `database/schema.sql` を参照してください。

## エラーレスポンス

```json
{
  "error": "Error Type",
  "message": "Error message",
  "code": 400
}
```

**HTTPステータスコード:**
- `200`: 成功
- `400`: リクエストエラー
- `401`: 認証エラー
- `404`: リソースが見つからない
- `500`: サーバーエラー

## サンプルコード

### JavaScript (Fetch API)

```javascript
// カテゴリ一覧取得
const response = await fetch('https://internal.ledian-clinic.com/api/v1/categories', {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY'
  }
});
const data = await response.json();
console.log(data.categories);
```

### cURL

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://internal.ledian-clinic.com/api/v1/categories
```

## データ同期

- **更新頻度**: リアルタイム（内部サイトで更新されたら即座に反映）
- **キャッシュ**: 推奨キャッシュ時間は5分程度

## 問い合わせ

API仕様に関する質問は、エンジニアまでご連絡ください。



