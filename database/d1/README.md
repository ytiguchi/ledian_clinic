# D1 マイグレーション管理

## 📁 マイグレーションファイル

- `001_init.sql` - 初期スキーマ（categories, subcategories, treatments, treatment_plans等）
- `002_add_before_afters.sql` - 症例写真テーブル追加
- `003_add_campaigns.sql` - キャンペーンテーブル追加

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


