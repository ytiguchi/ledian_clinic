# nodejs_compat フラグ設定メモ

## 修正内容

`wrangler.internal.toml` に `compatibility_flags = ["nodejs_compat"]` を追加する場合の設定例です。

これにより、Node.jsの組み込みモジュール（`fs`、`child_process`など）がCloudflare Workers環境で使用可能になります。

## wrangler.internal.toml

```toml
name = "ledian-clinic-internal"
compatibility_date = "2025-01-01"

pages_build_output_dir = "apps/internal-site/dist"

[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"
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

ブラウザで `http://localhost:8788/pricing` にアクセスすると、データが表示されるはずです。


