# ローカルでデータを表示する手順

## ⚠️ 重要な前提条件

1. **Node.js v20以上が必要**
   ```bash
   source ~/.nvm/nvm.sh
   nvm use 20
   ```

2. **Astroの設定が必要**
   - `output: "server"` が設定されていること
   - Cloudflare adapterが設定されていること

3. **データベースにデータが入っていること**
   - サンプルデータは投入済み（`database/d1/seed-sample.sql`）

## 🚀 起動手順

### ステップ1: Node.jsバージョン確認

```bash
source ~/.nvm/nvm.sh
nvm use 20
node --version  # v20.x.x を確認
```

### ステップ2: ビルド

```bash
cd apps/internal-site
npm run build
```

### ステップ3: wrangler pages dev で起動

```bash
cd apps/internal-site
wrangler pages dev dist --local --port 8788
```

### ステップ4: ブラウザで確認

- http://localhost:8788/pricing

## 🔍 トラブルシューティング

### APIが404を返す

- ビルドが成功しているか確認
- `output: "server"` が設定されているか確認

### データが表示されない

- データベースにデータが入っているか確認
- ブラウザのコンソールでエラーを確認
- APIのレスポンスを確認: `curl http://localhost:8788/api/categories`

### wrangler pages devが起動しない

- Node.js v20以上を使用しているか確認
- ポート8788が既に使用されていないか確認
- エラーメッセージを確認

