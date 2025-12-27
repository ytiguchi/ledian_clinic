# ローカル開発環境でのデータ表示方法

## ⚠️ 重要な注意点

**`npm run dev`（Astro開発サーバー）では、API Routes（`/api/*`）は動作しません。**

理由：
- Astroの開発サーバーは静的サイトとして動作
- `locals.runtime.env`（D1バインド）が利用できない
- API Routesは空の配列を返す

## ✅ 解決方法: wrangler pages dev を使用

### ステップ1: ビルド

```bash
cd apps/internal-site
npm run build
```

### ステップ2: wrangler pages dev で起動

```bash
# package.jsonに追加済みのスクリプトを使用
npm run dev:local

# または直接実行
wrangler pages dev dist --local
```

これで、ローカルD1データベースに接続してAPIが動作します。

## 📊 データ投入済み

- ✅ サンプルデータ投入済み（`database/d1/seed-sample.sql`）
  - カテゴリ: 3件（スキンケア、医療脱毛、アートメイク）
  - サブカテゴリ: 3件
  - 施術: 3件
  - 料金プラン: 4件

## 🔄 ワークフロー

### UI開発時
```bash
npm run dev  # 高速なホットリロード、UI確認用
```

### API動作確認時
```bash
npm run build
npm run dev:local  # wrangler pages dev、D1使用可能
```

## 💡 今後の改善案

1. **モックデータモード**: `npm run dev`でモックデータを表示
2. **開発用プロキシ**: APIリクエストを`wrangler pages dev`にプロキシ
3. **Viteプラグイン**: 開発時にD1をエミュレート


