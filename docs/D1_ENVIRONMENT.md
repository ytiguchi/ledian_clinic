# D1データベース環境について

## ⚠️ 注意: 内部サイトは本番環境のみ

内部サイト（internal）はプレビュー環境を廃止し、本番環境のみで運用します。`wrangler.internal.toml` には `preview_database_id` を設定しません。

---

## 環境別データベース

### internal（本番のみ）

`wrangler.internal.toml` の設定：

```toml
[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"
```

### public（本番 + プレビュー）

`wrangler.toml` の設定：

```toml
[[d1_databases]]
binding = "DB"
database_name = "ledian-public-prod"
database_id = "1528077a-91e3-421f-adab-38e7fd412734"
preview_database_id = "37a6de04-9beb-4f46-9531-653fe3fb64d7"
```

---

## 環境の切り替え

- **internal production**: `database_id` が使用される（preview は使用しない）
- **public production**: `database_id` が使用される
- **public preview**: `preview_database_id` が使用される（`--preview` を指定）
- **ローカル開発**: `.wrangler/state/v3/d1` 内のローカルSQLiteファイル（`--local` を指定）

---

## マイグレーションの適用

```bash
# internal production
wrangler d1 migrations apply ledian-internal-prod --config wrangler.internal.toml --remote

# public production
wrangler d1 migrations apply ledian-public-prod --config wrangler.toml --remote

# public preview
wrangler d1 migrations apply ledian-public-prod --config wrangler.toml --remote --preview
```

## データ投入

```bash
# internal production
wrangler d1 execute ledian-internal-prod --config wrangler.internal.toml --remote --file database/d1/seed-all.sql

# public production
wrangler d1 execute ledian-public-prod --config wrangler.toml --remote --file database/d1/seed-all.sql

# public preview
wrangler d1 execute ledian-public-prod --config wrangler.toml --remote --preview --file database/d1/seed-all.sql
```

## 注意点

- internal は **productionのみ** で運用します（preview は使用しません）
- public の production と preview は **完全に別DB** です
- ローカル開発環境のデータも独立しています
