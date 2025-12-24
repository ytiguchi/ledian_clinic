# nodejs_compat フラグ追加完了

## 修正内容

`apps/internal-site/wrangler.toml` に `compatibility_flags = ["nodejs_compat"]` を追加しました。

これにより、Node.jsの組み込みモジュール（`fs`、`child_process`など）がCloudflare Workers環境で使用可能になります。

## wrangler.toml

```toml
name = "ledian-clinic-internal"
compatibility_date = "2025-01-01"
compatibility_flags = ["nodejs_compat"]

pages_build_output_dir = "dist"

[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"
preview_database_id = "86b12d9e-8578-4f08-a49b-9d8be919f486"
migrations_dir = "../../database/d1/migrations"
```

## 起動方法

```bash
cd apps/internal-site

# Node.js v20を使用
source ~/.nvm/nvm.sh
nvm use 20

# ビルド（成功するはず）
npm run build

# wrangler pages dev で起動
wrangler pages dev dist --local --port 8788
```

ブラウザで http://localhost:8788/pricing にアクセスすると、データが表示されるはずです。

