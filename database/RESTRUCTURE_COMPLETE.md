# テーブル構造再構築完了報告

## 実施内容

本番サイトの構造（サブカテゴリ = 各施術ページ `/service/{slug}/`）に合わせて、すべてのテーブルを `treatment_id` ベースから `subcategory_id` ベースに変更しました。

## 更新したファイル

### D1 (SQLite) マイグレーション
- ✅ `database/d1/migrations/005_restructure_to_subcategory_based.sql` - 初期移行
- ✅ `database/d1/migrations/006_finalize_subcategory_structure.sql` - テーブル再作成
- ✅ `database/d1/migrations/007_update_treatment_details_to_subcategory.sql` - treatment_details系更新

### PostgreSQL スキーマ
- ✅ `database/schema.sql` - treatment_plans, treatment_option_mappings を更新
- ✅ `database/schema_content.sql` - treatment_details, treatment_flows, treatment_cautions, treatment_faqs, treatment_tags, treatment_before_afters, treatment_relations, campaign_treatments を更新

### D1 (SQLite) スキーマ
- ✅ `database/schema_d1.sql` - treatment_plans, treatment_option_mappings, v_price_list を更新

### データ定義
- ✅ `data/catalog/categories.yml` - 本番サイトの13カテゴリを定義
- ✅ `data/catalog/subcategories.yml` - 本番サイトの28サブカテゴリ（各施術ページ）を定義

## 変更されたテーブル

| テーブル | 変更内容 |
|---------|---------|
| `treatment_plans` | `treatment_id` → `subcategory_id` |
| `treatment_option_mappings` | `treatment_id` → `subcategory_id` |
| `treatment_before_afters` | `treatment_id` → `subcategory_id` |
| `treatment_details` | `treatment_id` → `subcategory_id` (UNIQUE制約追加) |
| `treatment_flows` | `treatment_id` → `subcategory_id` |
| `treatment_cautions` | `treatment_id` → `subcategory_id` |
| `treatment_faqs` | `treatment_id` → `subcategory_id` |
| `treatment_tags` | `treatment_id` → `subcategory_id` |
| `treatment_relations` | `treatment_id` → `subcategory_id`, `related_treatment_id` → `related_subcategory_id` |
| `campaign_treatments` | `treatment_id` → `subcategory_id` |

## 次のステップ

### 1. マイグレーション実行（D1）
```bash
# ローカルDBでテスト
wrangler d1 migrations apply DB --local

# 本番DBに適用
wrangler d1 migrations apply DB
```

### 2. APIエンドポイント更新
- `/api/pricing`: `treatment_id` → `subcategory_id` パラメータに変更
- `/api/treatments/[id]` → `/api/subcategories/[id]` に変更
- `/api/treatments/[id]/details` → `/api/subcategories/[id]/details` に変更
- `/api/treatments/[id]/flows` → `/api/subcategories/[id]/flows` に変更
- `/api/treatments/[id]/cautions` → `/api/subcategories/[id]/cautions` に変更
- `/api/treatments/[id]/faqs` → `/api/subcategories/[id]/faqs` に変更
- `/api/treatments/[id]/tags` → `/api/subcategories/[id]/tags` に変更
- `/api/before-afters`: `treatment_id` → `subcategory_id` パラメータに変更

### 3. フロントエンド更新
- 料金管理ページ: `treatment_id` → `subcategory_id`
- 施術管理ページ: `/treatments/[id]/edit` → `/subcategories/[id]/edit`
- 症例写真管理ページ: `treatment_id` → `subcategory_id`

### 4. PostgreSQLデータベース更新
PostgreSQL版のデータベースにも同じ変更を適用する必要があります。

## 注意事項

- `treatments` テーブルは今後使用しませんが、既存データとの互換性のため一時的に残しています
- 既存データがある場合、マイグレーション前にデータのバックアップを取得してください
- マイグレーションは段階的に実行し、各段階でデータの整合性を確認してください

