# API動作確認・デバッグガイド

## 🔍 問題: データが表示されない

### 原因

1. **Astroの設定**: `output: "server"`が必要
2. **Cloudflare adapter**: 設定が必要
3. **開発サーバー**: `npm run dev`ではなく`wrangler pages dev`を使用

## ✅ 解決手順

### 1. astro.config.mjsの確認

```javascript
import { defineConfig } from "astro/config";
import cloudflare from "@astrojs/cloudflare";

export default defineConfig({
  srcDir: "./src",
  outDir: "./dist",
  output: "server",  // ← これが必要！
  adapter: cloudflare({
    platformProxy: {
      enabled: true
    }
  }),
  server: {
    host: true,
    port: 4321
  }
});
```

### 2. ビルド

```bash
cd apps/internal-site
npm run build
```

### 3. wrangler pages dev で起動

```bash
wrangler pages dev dist --config ../../wrangler.internal.toml --local --port 8788
```

### 4. API動作確認

```bash
# カテゴリ一覧
curl http://localhost:8788/api/categories

# 料金プラン一覧
curl http://localhost:8788/api/pricing
```

## 📊 期待されるレスポンス

### `/api/categories`

```json
{
  "categories": [
    {
      "id": "cat001",
      "name": "スキンケア",
      "slug": "skincare",
      ...
    }
  ]
}
```

### `/api/pricing`

```json
{
  "plans": [
    {
      "id": "plan001",
      "plan_name": "1回",
      "treatment_name": "ウルトラセルZi",
      "price": 50000,
      ...
    }
  ]
}
```

## 🐛 トラブルシューティング

### APIが404を返す

- `output: "server"`が設定されているか確認
- ビルドが成功しているか確認
- `wrangler pages dev`が正しく起動しているか確認

### APIが空の配列を返す

- データベースにデータが入っているか確認
- ローカルD1にデータを投入済みか確認

### エラーメッセージが出る

- ブラウザのコンソールを確認
- wranglerのログを確認

