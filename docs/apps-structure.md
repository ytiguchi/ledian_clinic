# アプリ構成（社内向け/一般向けの2サイト運用）

共通の正規化データ（`data/`）をソースに、2つの出力を管理します。
- 一般向けサイト: `apps/public-site/`（Cloudflare Pages想定）
- 社内向けサイト: `apps/internal-site/`（Cloudflare Access + Lineworks SSOで保護）

## ディレクトリ方針
- `apps/public-site/`: 外部公開するUI。LP/料金表などを表示。ビルド成果物はこの中で完結（例: `apps/public-site/dist/`）。Pages の `pages_build_output_dir` をここに合わせる。
- `apps/internal-site/`: 社内閲覧用UI。料金編集ビュー、Bot/カウンセリング用のプレビュー、CSV/PDFダウンロードなど。Cloudflare Access バリア前提。
- 双方ともデータは `data/` を直接読むか、`scripts/` 経由で生成した JSON/DB を参照する。

## データフロー例
```
data/ (YAML正規化)
  ├ catalog/
  ├ pricing/
  ├ content/{web|bot|counseling}/
  └ shared/
   ↓ scripts/seed_from_yaml (生成)
   → D1 (DB)  # Pages Functions から参照
   → outputs/json  # 静的JSONとして配信する場合
```

## フレームワーク（提案）
- 両サイトとも Astro を採用（軽量で静的/動的の両方に対応しやすい）。
- public-site: Astro + CSR最小限、出力 `apps/public-site/dist`（`wrangler.toml` もここに合わせ済み）。
- internal-site: Astro + Cloudflare Access/Lineworks SSO で保護。`wrangler.internal.toml` を別途用意してビルド出力パスを定義する想定。

## 推奨ビルド/デプロイ単位
- `apps/public-site`: GitHub Actions → Cloudflare Pages deploy (prod/stg)。Astro build → `dist`。
- `apps/internal-site`: 同様に Pages deploy だが、Access で保護。ステージングは `preview_database_id` を参照。

## 今後のToDo（実装前）
- `apps/public-site/` と `apps/internal-site/` のフレームワークを決定（例: React/Next, SvelteKit, Astro 等）。
- `wrangler.toml` の `pages_build_output_dir` を実ビルド先に合わせる（public-site 内の dist/out など）。
- CI スクリプトで `apps/*` ごとに build → deploy → (必要なら) D1 migrate/seed を順序化。
