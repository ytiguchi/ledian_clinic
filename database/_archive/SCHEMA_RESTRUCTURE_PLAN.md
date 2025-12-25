# テーブル構造の再構築計画

## 概要

本番サイトの構造（サブカテゴリ = 各施術ページ `/service/{slug}/`）に合わせて、すべてのテーブルを `treatment_id` ベースから `subcategory_id` ベースに変更します。

## 変更理由

- **本番サイトの構造**: サブカテゴリ（例：ポテンツァ、エリシスセンス）が直接 `/service/{slug}/` として独立したページ
- **データ整合性**: テーブル構造と実際のサイト構造を一致させる
- **運用の簡素化**: `treatments` テーブルの中間層を排除し、直接 `subcategories` に紐づける

## 変更対象テーブル

### 1. 料金管理関連
- ✅ `treatment_plans`: `treatment_id` → `subcategory_id`
- ✅ `treatment_option_mappings`: `treatment_id` → `subcategory_id`

### 2. 症例写真関連
- ✅ `treatment_before_afters`: `treatment_id` → `subcategory_id`

### 3. 施術詳細情報関連
- ✅ `treatment_details`: `treatment_id` → `subcategory_id`
- ✅ `treatment_flows`: `treatment_id` → `subcategory_id`
- ✅ `treatment_cautions`: `treatment_id` → `subcategory_id`
- ✅ `treatment_faqs`: `treatment_id` → `subcategory_id`
- ✅ `treatment_tags`: `treatment_id` → `subcategory_id`

### 4. キャンペーン関連
- ⚠️ `campaign_plans`: `treatment_plan_id` は変更不要（treatment_plans の id を参照）
- ⚠️ `campaign_treatments`: `treatment_id` → `subcategory_id`（ただし、campaign_plans を推奨）

### 5. treatments テーブル
- ⚠️ 今後は使用しない（既存データとの互換性のため一時的に残す）

## マイグレーション手順（D1）

1. **005_restructure_to_subcategory_based.sql**
   - 新しいカラム（`*_new`）を追加
   - 既存データを移行

2. **006_finalize_subcategory_structure.sql**
   - テーブル再作成（SQLiteの制約のため）
   - 旧カラムを削除

3. **007_update_treatment_details_to_subcategory.sql**
   - treatment_details 系テーブルの変更

## マイグレーション手順（PostgreSQL）

PostgreSQL版のスキーマファイルも同様に更新する必要があります：
- `database/schema.sql`
- `database/schema_content.sql`

## 影響範囲

### API変更が必要
- `/api/pricing`: `treatment_id` → `subcategory_id`
- `/api/treatments/[id]`: パスを `/api/subcategories/[id]` に変更
- `/api/treatments/[id]/details`: `/api/subcategories/[id]/details` に変更
- `/api/treatments/[id]/flows`: `/api/subcategories/[id]/flows` に変更
- `/api/treatments/[id]/cautions`: `/api/subcategories/[id]/cautions` に変更
- `/api/treatments/[id]/faqs`: `/api/subcategories/[id]/faqs` に変更
- `/api/treatments/[id]/tags`: `/api/subcategories/[id]/tags` に変更
- `/api/before-afters`: `treatment_id` → `subcategory_id`

### フロントエンド変更が必要
- 料金管理ページ: `treatment_id` → `subcategory_id`
- 施術管理ページ: `/treatments/[id]/edit` → `/subcategories/[id]/edit`
- 症例写真管理ページ: `treatment_id` → `subcategory_id`

## 注意事項

1. **既存データの移行**: 既存の `treatment_id` から `subcategory_id` を取得する必要がある
2. **外部キー制約**: すべての `treatment_id` 参照を `subcategory_id` に変更
3. **インデックス**: 新しい `subcategory_id` カラムにインデックスを追加
4. **ビュー**: `v_price_list` などのビューも更新が必要

## 実装順序

1. ✅ マイグレーションファイル作成（D1）
2. ⏳ PostgreSQL版スキーマ更新
3. ⏳ APIエンドポイント更新
4. ⏳ フロントエンド更新
5. ⏳ テスト
6. ⏳ データ移行実行
7. ⏳ 本番環境への反映

