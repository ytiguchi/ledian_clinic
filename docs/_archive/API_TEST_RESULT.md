# API動作確認結果

## 現在の状況

wrangler pages dev が起動しています。

## 確認方法

### 1. APIエンドポイントの確認

```bash
# カテゴリ一覧
curl http://localhost:8788/api/categories

# 料金プラン一覧
curl http://localhost:8788/api/pricing
```

### 2. ブラウザで確認

- `http://localhost:8788/pricing`
- `http://localhost:8788/api/categories`

## 期待される結果

- APIが正常に動作し、データが返される
- `/pricing`ページでデータが表示される

## データ投入済み

- カテゴリ: 3件
- 料金プラン: 4件


