# D1 マイグレーション管理

## 現行スキーマ

以下のマイグレーションが現行の内部サイトスキーマです：

- `001_init.sql` - 初期スキーマ（4階層の基本）
- `002_add_before_afters.sql` - 症例写真
- `003_add_campaigns.sql` - キャンペーン
- `004_add_treatment_details.sql` - 施術詳細/タグ/フロー/FAQ
- `008_restructure_to_4_tier.sql` - 4階層構造への再構築
- `009_seed_4_tier_data.sql` - 4階層向け最低限のシード
- `010_restore_content_tables_to_treatment_id.sql` - content系を treatment_id 参照に整合
- `011_add_product_launches.sql` - 商品ローンチ管理
- `012_seed_product_launches.sql` - ローンチ管理シード
- `013_extend_product_launches.sql` - ローンチ拡張

### 4階層構造

```
Category (カテゴリ)
  └── Subcategory (サブカテゴリ/機器)
        └── Treatment (施術メニュー)
              └── TreatmentPlan (料金プラン)
```

### 関連テーブル（抜粋）

- `treatment_before_afters` - 症例写真
- `treatment_details` / `treatment_flows` / `treatment_faqs` - 施術詳細
- `treatment_tags` / `tags` - タグ
- `product_launches` / `launch_tasks` - 商品ローンチ管理

## 📁 マイグレーションファイル

| ファイル | 状態 | 説明 |
|---------|------|------|
| 001-004 | 現行 | 基本スキーマ |
| 005-007 | 旧版 | サブカテゴリ基準の過去移行 |
| 008-010 | 現行 | 4階層構造 + content整合 |
| 011-013 | 現行 | 商品ローンチ管理 |

`database/d1/migrations/_archive/` は廃止・検証用です（本番/ローカルには適用しない）。

## 🚀 マイグレーション実行方法

### 方法1: スクリプトを使用（推奨）

```bash
# internal production
./database/d1/migrate.sh internal prod

# public staging
./database/d1/migrate.sh public stg

# public production
./database/d1/migrate.sh public prod
```

### 方法2: wrangler コマンドを直接実行

```bash
# internal production
npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote

# public staging
npx wrangler@4.56.0 d1 migrations apply ledian-public-prod \
  --config wrangler.toml \
  --remote --preview

# public production
npx wrangler@4.56.0 d1 migrations apply ledian-public-prod \
  --config wrangler.toml \
  --remote
```

## 📋 マイグレーション状態確認

```bash
# internal production の適用済みマイグレーション確認
npx wrangler@4.56.0 d1 migrations list ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote

# public staging の適用済みマイグレーション確認
npx wrangler@4.56.0 d1 migrations list ledian-public-prod \
  --config wrangler.toml \
  --remote --preview
```

## ⚠️ 注意事項

1. **production への適用は慎重に**
   - public は staging でテストしてから production に適用
   - production 適用時は確認プロンプトが表示されます

2. **マイグレーションファイルの命名規則**
   - `00X_description.sql` の形式
   - 番号は連番で、順序が重要

3. **ロールバック**
   - D1はマイグレーションのロールバック機能がないため、必要に応じて新しいマイグレーションで修正してください

## 🔍 トラブルシューティング

### マイグレーションが適用されない
- `migrations_dir` のパスが `wrangler.internal.toml` / `wrangler.toml` で正しく設定されているか確認
- マイグレーションファイルの構文エラーを確認

### エラーが発生した場合
- エラーメッセージを確認
- データベースの現在の状態を確認
- 必要に応じてマイグレーションファイルを修正して再実行

