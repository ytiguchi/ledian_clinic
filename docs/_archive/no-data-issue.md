# データが表示されない問題の解決方法

## 🔍 問題の原因

1. **データベースが空**
   - マイグレーションは完了しているが、データが入っていない
   - カテゴリ、施術、料金プランのデータが必要

2. **開発サーバーの問題**
   - `npm run dev`（Astro開発サーバー）では、API Routesが動作しない
   - `locals.runtime.env`が利用できないため、APIが空の配列を返す

## ✅ 解決方法

### 方法1: サンプルデータを投入（完了）

```bash
# サンプルデータを投入
npx wrangler@4.56.0 d1 execute ledian-internal-prod \
  --config wrangler.internal.toml \
  --local \
  --file database/d1/seed-sample.sql
```

### 方法2: wrangler pages dev を使用

Astro開発サーバーではAPIが動作しないため、`wrangler pages dev`を使用：

```bash
cd apps/internal-site

# 1. ビルド
npm run build

# 2. wrangler pages dev で起動
npm run dev:local
# または
wrangler pages dev dist --local
```

### 方法3: 既存データの移行

PostgreSQLからD1へのデータ移行スクリプトを作成する必要があります。

## 📋 現在の状況

- ✅ マイグレーション: 完了
- ✅ サンプルデータ: 投入済み
- ⚠️ 開発サーバー: `npm run dev`ではAPIが動作しない

## 🎯 次のステップ

1. `wrangler pages dev`で起動してAPIの動作確認
2. または、既存のPostgreSQLデータをD1に移行


