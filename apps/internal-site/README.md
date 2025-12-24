# Internal Site (Astro minimal)

- フレームワーク: Astro 5.x (minimal scaffold)
- 認証: Cloudflare Access + Lineworks SSO 前提（公開せず）。
- Pages Project: `wrangler.internal.toml` で設定（出力: `apps/internal-site/dist`）。
- DB: D1 バインド `DB`（prod/stg）。

## 🚀 開発

```bash
npm install   # 初回のみ
npm run dev   # http://localhost:4321
npm run build # dist
npm run preview
```

## 📁 ディレクトリ構造（初期）
```
apps/internal-site/
├── astro.config.mjs
├── package.json
├── tsconfig.json
└── src/
    └── pages/
        └── index.astro   # 仮トップ
```

## 🔌 D1統合
- マイグレーション: `npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod --config ../../wrangler.internal.toml --remote`（stgは --preview）
- 今後、Functions/API を追加して D1 からカテゴリ/施術/料金を読み込む予定。

## TODO
- D1 参照のAPI/Functions実装
- Access/Lineworks のグループ情報でロール分け（必要なら）
- Bot/カウンセリング/エクスポート用のビューを追加
