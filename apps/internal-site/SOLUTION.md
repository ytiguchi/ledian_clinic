# 解決策

## 問題

`/api/pricing` が404エラーを返す

## 原因

Astroのルーティングでは、`pricing/`ディレクトリと`pricing.ts`ファイルが同時に存在する場合、ルーティングが競合する可能性があります。

現在の構造：
- `src/pages/api/pricing/index.ts` → `/api/pricing` (期待)
- `src/pages/api/pricing/[id].ts` → `/api/pricing/[id]` (必要)

## 確認方法

1. ビルドログで `λ src/pages/api/pricing/index.ts` が表示されているか確認
2. `dist/_worker.js/pages/api/pricing.astro.mjs` が生成されているか確認
3. サーバーログでエラーが発生していないか確認

## 現在の状態

- ✅ `pricing/index.ts` が存在
- ✅ `pricing/[id].ts` が存在
- ⚠️ ビルドログに `pricing/index.ts` が表示されていない

## 次のステップ

サーバーを再起動して、ブラウザで確認してください。



