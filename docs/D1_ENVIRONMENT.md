# D1データベース環境について

## ⚠️ 注意: 内部サイトはプレビュー環境を廃止

内部サイト（internal）では、プレビュー環境を廃止し、本番環境のみで運用します。

詳細は [内部サイト設定](./INTERNAL_SITE_CONFIG.md) を参照してください。

---

## 環境別データベース（参考: 公開サイト用）

Cloudflare D1では、本番環境とプレビュー環境で別々のデータベースを使用できます（公開サイトなどで使用する場合）。

### 現在の設定

`apps/internal-site/wrangler.toml` の設定：

```toml
[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"      # 本番環境用
preview_database_id = "86b12d9e-8578-4f08-a49b-9d8be919f486"  # プレビュー環境用
```

### 環境の切り替え

- **本番環境（Production）**: `database_id` が使用される
  - Cloudflare Pagesの本番デプロイ時に使用
  - `wrangler d1 execute --remote` で操作

- **プレビュー環境（Preview）**: `preview_database_id` が使用される
  - Pull Requestのプレビュー環境やプレビューデプロイ時に使用
  - `wrangler d1 execute --remote --preview` で操作

- **ローカル開発環境**: `.wrangler/state/v3/d1` 内のローカルSQLiteファイル
  - `wrangler d1 execute --local` で操作

### マイグレーションの適用

本番環境とプレビュー環境の両方にマイグレーションを適用する必要があります：

```bash
# 本番環境
cd apps/internal-site
wrangler d1 migrations apply ledian-internal-prod --remote

# プレビュー環境
wrangler d1 migrations apply ledian-internal-prod --remote --preview
```

### データ投入

本番環境とプレビュー環境に個別にデータを投入する必要があります：

```bash
# 本番環境にデータ投入
wrangler d1 execute ledian-internal-prod --remote --file ../../database/d1/seed-all.sql

# プレビュー環境にデータ投入
wrangler d1 execute ledian-internal-prod --remote --preview --file ../../database/d1/seed-all.sql
```

## 注意点

- 本番環境とプレビュー環境は**完全に別のデータベース**です
- 本番環境のデータを変更しても、プレビュー環境には影響しません
- ローカル開発環境のデータも独立しています
- デプロイ時に自動で切り替わるため、コードを変更する必要はありません

