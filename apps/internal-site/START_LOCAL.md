# ローカル開発サーバー起動方法

## 起動コマンド

```bash
cd apps/internal-site

# Node.js v20を使用
source ~/.nvm/nvm.sh
nvm use 20

# ビルド
npm run build

# wrangler pages dev で起動（ローカルD1を使用）
wrangler pages dev dist --local --port 8788
```

## 確認

ブラウザで以下にアクセス:
- http://localhost:8788/pricing
- http://localhost:8788/api/categories

## データ投入済み

サンプルデータ（3カテゴリ、4料金プラン）がローカルD1に投入済みです。

