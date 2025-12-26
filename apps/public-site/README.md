# Public Site (Astro minimal)

- フレームワーク: Astro 5.x (minimal scaffold)
- アダプター: `@astrojs/cloudflare`（Cloudflare Pages + D1 前提）
- ビルド出力: `apps/public-site/dist`（`wrangler.toml` と一致）
- DB: D1 バインド `DB`（public prod/stg）

## 開発
```bash
npm install   # 初回
npm run dev   # http://localhost:4320
npm run build
npm run preview
```

## デプロイ例
```bash
npx wrangler@4.56.0 pages deploy dist --project-name ledian-clinic --config ../../wrangler.toml
```

## TODO
- D1 参照の API/Functions 実装（価格/メニュー表示）
- デザイン実装（公開用UI）
- internal とは別に public D1 を参照
