# 内部サイト（Internal Site）設定

## 概要

内部サイトは本番環境のみで運用します。プレビュー環境は廃止されています。

## データベース設定

### 本番環境のみ使用

`wrangler.internal.toml`:

```toml
[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"
# プレビュー環境は廃止。本番環境のみ使用
```

### KV Namespaces設定

```toml
[[kv_namespaces]]
binding = "SESSION"
id = "ca140e5a5a1b4712956b3b33a463d873"
# プレビュー環境は廃止。本番環境のみ使用
```

### pages dev の設定ファイル

`wrangler pages dev` はカスタムパスの設定ファイルを読めないため、ローカル開発では `apps/internal-site/wrangler.toml` を使用します。

## 環境構成

- **本番環境（Production）**: 本番データベースを使用
- **プレビュー環境**: 廃止（本番と同じデータベースを使用しない）
- **ローカル開発環境**: ローカルのSQLiteファイル（`.wrangler/state/v3/d1`）

## 運用方針

### 理由

- 運用の簡素化（1つのDBのみ管理）
- データの一貫性（本番データを常に参照）
- 内部サイトは本番環境のみで運用するため、プレビュー環境は不要

### 注意事項

- プレビュー環境のデプロイも本番データベースに接続されます
- 本番データベースへの操作は慎重に行ってください
- マイグレーションやデータ投入は1回のみで本番環境に反映されます

## マイグレーション適用

```bash
# 本番環境（--remote）
wrangler d1 migrations apply ledian-internal-prod --config wrangler.internal.toml --remote

# ローカル環境（--local）
wrangler d1 migrations apply ledian-internal-prod --config wrangler.internal.toml --local
```

## データ投入

```bash
# 本番環境（--remote）
wrangler d1 execute ledian-internal-prod --config wrangler.internal.toml --remote --file database/d1/seed-all.sql

# ローカル環境（--local）
wrangler d1 execute ledian-internal-prod --config wrangler.internal.toml --local --file database/d1/seed-all.sql
```

## デプロイ

```bash
# ビルド
npm run build

# デプロイ
wrangler pages deploy apps/internal-site/dist --project-name ledian-clinic-internal
```

## Cloudflare Pages設定

Cloudflare Dashboardでプレビュー環境の自動デプロイを無効化することを推奨します：

1. Cloudflare Dashboard → Pages → `ledian-clinic-internal`
2. Settings → Builds & deployments
3. Preview deployments を無効化（任意）

ただし、設定ファイル上では`preview_database_id`と`preview_id`を削除しているため、プレビュー環境がデプロイされても本番データベースを使用します。

