# CI/デプロイ手順（Cloudflare Pages + D1）

internal をマスターにし、public はマスク/抽出データを同期する前提。Actions での想定手順をまとめる。

## 前提
- D1: internal は prod のみ、public は prod/stg が存在し、`database/d1/migrations/001_init.sql` が適用済み。
- wrangler設定: `wrangler.internal.toml`（internal）、`wrangler.toml`（public）。
- ビルド出力: Astro想定（`apps/public-site/dist`, `apps/internal-site/dist`）。実際のFWに合わせて変更。

## 推奨ジョブ構成（例: GitHub Actions）
1) checkout + node 20 セットアップ  
2) 依存インストール（pnpm/yarn/npm 任意）  
3) build (public/internal)  
4) migrations apply (public stg)  
5) mask/seed public (stg)  
6) Pages deploy (public stg)  
7) 手動承認後に prod を実行（internal prod → public prod）

## コマンド例
- マイグレーション（stg）  
  - public: `npx wrangler@4.56.0 d1 migrations apply ledian-public-prod --config wrangler.toml --remote --preview`
- マイグレーション（prod）  
  - internal: `npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod --config wrangler.internal.toml --remote`
  - public: `npx wrangler@4.56.0 d1 migrations apply ledian-public-prod --config wrangler.toml --remote`
- シード（スクリプト実装後の想定）  
  - internal prod: `npx wrangler@4.56.0 d1 execute ledian-internal-prod --config wrangler.internal.toml --remote --file outputs/seed-internal.sql`
  - public stg: `npx wrangler@4.56.0 d1 execute ledian-public-prod --config wrangler.toml --remote --preview --file outputs/seed-public.sql`
  - public prod: `npx wrangler@4.56.0 d1 execute ledian-public-prod --config wrangler.toml --remote --file outputs/seed-public.sql`
- Pages deploy（フレームワークに応じて）  
  - `npx wrangler@4.56.0 pages deploy apps/public-site/dist --project-name ledian-clinic`
  - `npx wrangler@4.56.0 pages deploy apps/internal-site/dist --project-name ledian-clinic-internal`

## Secrets/環境変数
- GitHub Actions シークレット: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`（Pages/D1権限あり）。
- wrangler は `wrangler login` で発行したOAuthでも可だが、CIではAPIトークン推奨。

## TODO
- `scripts/seed_from_yaml` と `scripts/mask_for_public` の実装後に実コマンドを反映。
- ビルド/デプロイコマンドは採用フレームワークに合わせて更新。
