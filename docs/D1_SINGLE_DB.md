# D1データベース設定（本番一本化）

## ⚠️ 重要: プレビュー環境は廃止

内部サイト（internal）では、**プレビュー環境を廃止**し、本番環境のみで運用します。

## 設定方針

- **本番環境のみ使用**: プレビュー環境は廃止
- **データベース**: 本番データベースのみ
- **KV Namespaces**: 本番KVのみ

### 理由

- 運用の簡素化（1つのDBのみ管理）
- データの一貫性（本番データを常に参照）
- 内部サイトは本番環境のみで運用するため、プレビュー環境は不要

## 設定ファイル

`wrangler.internal.toml`:

```toml
[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"
# プレビュー環境は廃止。本番環境のみ使用

[[kv_namespaces]]
binding = "SESSION"
id = "ca140e5a5a1b4712956b3b33a463d873"
# プレビュー環境は廃止。本番環境のみ使用
```

## 注意点

- `preview_database_id`は**削除**されています
- `preview_id`（KV）も**削除**されています
- プレビュー環境がデプロイされても本番データベースに接続されます
- 本番データベースへの操作は慎重に行ってください

## マイグレーション適用

```bash
# 本番環境（--remote）
wrangler d1 migrations apply ledian-internal-prod --config wrangler.internal.toml --remote
```

## データ投入

```bash
# 本番環境（--remote）
wrangler d1 execute ledian-internal-prod --config wrangler.internal.toml --remote --file database/d1/seed-all.sql
```

## 関連ドキュメント

- [内部サイト設定](./INTERNAL_SITE_CONFIG.md) - 詳細な設定と運用方針
