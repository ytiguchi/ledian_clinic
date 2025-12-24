# APIルーティング修正

## 修正内容

### 1. `export const prerender = false;` を追加

APIルートに`prerender = false`を追加して、サーバーサイドレンダリングを強制しました。

- ✅ `src/pages/api/categories.ts`
- ✅ `src/pages/api/pricing/index.ts`

### 2. マイグレーション適用完了

すべてのマイグレーションが正常に適用され、データも投入済みです。

## 次のステップ

サーバーを再起動してください：

```bash
cd apps/internal-site
npm run build
wrangler pages dev dist --local --port 8788
```

その後、ブラウザで確認：
- http://localhost:8788/pricing
- http://localhost:8788/api/categories
- http://localhost:8788/api/pricing

エラーが解消されているはずです！



