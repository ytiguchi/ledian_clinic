# D1 マイグレーション管理

## 現行スキーマ

以下のマイグレーションが現行の本番スキーマです：

- `010_new_schema.sql` - 4階層構造メインスキーマ
- `011_service_content.sql` - WEBスクレイピングコンテンツ

### 4階層構造

```
Category (カテゴリ)
  └── Subcategory (サブカテゴリ/機器)
        └── Treatment (施術メニュー)
              └── TreatmentPlan (料金プラン)
```

### 関連テーブル

- `before_afters` - 症例写真
- `training_modules` - 研修コンテンツ
- `treatment_protocols` - 施術プロトコル
- `service_contents` - WEBコンテンツ (スクレイピング)

## 📁 マイグレーションファイル

| ファイル | 状態 | 説明 |
|---------|------|------|
| 001-009 | 旧版 | 010で置き換え済み (履歴として保持) |
| 010_new_schema.sql | 現行 | 4階層メインスキーマ |
| 011_service_content.sql | 現行 | サービスコンテンツテーブル |

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


