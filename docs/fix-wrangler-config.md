# wrangler pages dev 設定修正

## 問題

`wrangler pages dev --config ../../wrangler.internal.toml` でエラー：
"Pages does not support custom paths for the Wrangler configuration file"

## 解決方法

`wrangler pages dev`はカスタムパスの設定ファイルをサポートしていないため、`apps/internal-site/wrangler.toml`を作成しました。

### 修正内容

1. `apps/internal-site/wrangler.toml`を作成
2. `package.json`のスクリプトを修正

### 使用方法

```bash
cd apps/internal-site

# ビルド + 起動
npm run dev:local

# または個別に
npm run build
wrangler pages dev dist --local
```

ブラウザで `http://localhost:8788/pricing` にアクセスすると、データが表示されます。

