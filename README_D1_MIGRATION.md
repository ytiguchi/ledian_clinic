# D1 データベースマイグレーション実行手順

## 📋 現在の状況

マイグレーションファイルは作成済みですが、**まだ実行されていません**。

## ✅ 作成済みマイグレーション

1. `001_init.sql` - 基本テーブル（categories, subcategories, treatments, treatment_plans等）
2. `002_add_before_afters.sql` - 症例写真テーブル
3. `003_add_campaigns.sql` - キャンペーンテーブル

## 🚀 実行方法

### ステップ1: マイグレーション実行スクリプトを使用

```bash
# internal staging に適用
./database/d1/migrate.sh internal stg

# internal production に適用（確認プロンプトあり）
./database/d1/migrate.sh internal prod
```

### ステップ2: 実行結果の確認

```bash
# 適用済みマイグレーション一覧を確認
npx wrangler@4.56.0 d1 migrations list ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote --preview
```

## ⚠️ 重要事項

1. **まず staging でテスト**
   - production に適用する前に必ず staging（preview）でテストしてください

2. **マイグレーションの順序**
   - 001 → 002 → 003 の順で実行されます
   - 順序はファイル名の番号で決定されます

3. **既存データへの影響**
   - `CREATE TABLE IF NOT EXISTS` を使用しているため、既存テーブルがある場合はスキップされます
   - 新規テーブルの追加は安全です

## 🔧 手動実行（スクリプトを使わない場合）

```bash
# internal staging
cd /Users/iguchiyuuta/Dev/ledian_clinic
npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote \
  --preview
```

## 📝 次のステップ

マイグレーション実行後：
1. API経由でデータベースにアクセスできることを確認
2. 必要に応じてシードデータを投入
3. 各ページ（料金管理、キャンペーン管理等）が正常に動作することを確認



