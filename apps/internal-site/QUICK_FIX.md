# クイック修正手順

## 問題
- `/api/pricing` が404エラー
- `/api/categories` が500エラー

## 解決方法

### 1. サーバーを完全に停止
```bash
cd apps/internal-site
pkill -f "wrangler pages dev"
```

### 2. 再ビルド
```bash
npm run build
```

### 3. サーバーを起動
```bash
wrangler pages dev dist --local --port 8788
```

### 4. ブラウザで確認
- http://localhost:8788/pricing

## それでも動かない場合

AstroのAPIルートのファイル名を確認してください。`src/pages/api/pricing/index.ts`が`/api/pricing`として認識されるはずです。

もし認識されない場合は、`src/pages/api/pricing.ts`にリネームしてみてください。

