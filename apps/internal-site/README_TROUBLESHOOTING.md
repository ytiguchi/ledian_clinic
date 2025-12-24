# トラブルシューティングガイド

## `/api/pricing` が404エラーになる場合

### 現在の状態

- ✅ `src/pages/api/pricing.ts` が存在
- ✅ `src/pages/api/pricing/[id].ts` が存在（個別ID用）
- ✅ ビルドが成功（`pricing.astro.mjs`が生成されている）

### 確認手順

1. **サーバーを完全に停止**
   ```bash
   pkill -f "wrangler pages dev"
   ```

2. **クリーンビルド**
   ```bash
   cd apps/internal-site
   rm -rf dist
   npm run build
   ```

3. **サーバーを起動**
   ```bash
   wrangler pages dev dist --local --port 8788
   ```

4. **APIを直接テスト**
   ```bash
   curl http://localhost:8788/api/pricing
   curl http://localhost:8788/api/categories
   ```

### 期待される結果

- `/api/pricing` が200を返し、JSONデータを返す
- `/api/categories` が200を返し、JSONデータを返す

### それでも404が出る場合

Astroのルーティングの問題かもしれません。`pricing/`ディレクトリが存在するため、`pricing.ts`が無視されている可能性があります。

この場合は、`pricing/[id].ts`を別の場所に移動するか、ルーティング構造を見直す必要があります。



