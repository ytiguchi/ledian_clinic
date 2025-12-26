# クイックスタートガイド（整理中）

この内容は `docs/START.md` に統合していきます。まずはそちらを参照してください。

- `docs/START.md`

## 🚀 ローカルでデータを見る方法

### 現在の状況

- ✅ マイグレーション: 完了（ローカル・リモート両方）
- ✅ サンプルデータ: 投入済み（ローカル）
- ⚠️ **重要**: `npm run dev`ではAPIが動作しません

### データを表示する方法

```bash
cd apps/internal-site

# 1. ビルド
npm run build

# 2. wrangler pages dev で起動（ローカルD1を使用）
npm run dev:local
```

ブラウザで `http://localhost:8788` を開くと、データが表示されます。

## 📊 投入済みサンプルデータ

- **カテゴリ**: 3件（スキンケア、医療脱毛、アートメイク）
- **施術**: 3件（ウルトラセルZi、ポテンツァ、全身ワックス脱毛）
- **料金プラン**: 4件

## 🧱 4階層データ構造（内部サイト）

```
Category
  └── Subcategory
        └── Treatment
              └── Treatment Plan
```

D1の現行マイグレーション一覧は `database/d1/README.md` を参照。

## 🔄 2つの開発モード

### 1. UI開発モード（`npm run dev`）

```bash
npm run dev
```

- ✅ 高速なホットリロード
- ✅ UIの確認・デザイン調整に最適
- ❌ API Routesは動作しない（空の配列を返す）

### 2. API動作確認モード（`wrangler pages dev`）

```bash
npm run build
npm run dev:local
```

- ✅ D1データベースに接続
- ✅ API Routesが正常に動作
- ✅ データの表示・操作が可能
- ⚠️ ビルドが必要（開発中は少し遅い）

## 💡 推奨ワークフロー

1. **UI開発**: `npm run dev`でデザイン調整
2. **機能確認**: `npm run build && npm run dev:local`でAPI動作確認
3. **デプロイ前**: 最終確認


