# AI向けコンテキスト

このファイルはAIアシスタントがこのリポジトリを理解するための情報をまとめています。

## プロジェクト概要

**Ledian Clinic（レディアンクリニック六本木）** の施術メニュー・料金・症例写真を管理するシステム。

### 2つのアプリケーション

| アプリ | 役割 | URL |
|--------|------|-----|
| `apps/internal-site` | 管理画面（CMS） | https://ledian-clinic-internal.pages.dev |
| `apps/public-site` | 公開サイト | https://ledianclinic.jp (予定) |

**両サイトは同一のCloudflare D1データベースを共有**しています。

---

## 技術スタック

- **フレームワーク**: Astro 5.x（SSR）
- **データベース**: Cloudflare D1（SQLite互換）
- **ホスティング**: Cloudflare Pages
- **画像ストレージ**: Cloudflare R2
- **スタイリング**: Tailwind CSS + カスタムCSS

---

## データ構造（4階層）

```
Category（大カテゴリ: 肌治療、注入治療など）
  └── Subcategory（小カテゴリ: ポテンツァ、ボトックスなど）
        └── Treatment（施術: 各具体的な施術メニュー）
              └── TreatmentPlan（料金プラン: 回数・価格）
```

### 主要テーブル

| テーブル | 説明 |
|----------|------|
| `categories` | 大カテゴリ |
| `subcategories` | 小カテゴリ |
| `treatments` | 施術（231件） |
| `treatment_plans` | 料金プラン |
| `service_contents` | 施術詳細コンテンツ（28件、公開サイト詳細ページ用） |
| `campaigns` | キャンペーン/お知らせ |
| `treatment_before_afters` | 症例写真 |

---

## 重要なファイル

### ドキュメント

- `docs/INDEX.md` - ドキュメント一覧（入口）
- `docs/START.md` - ローカル開発の起動手順
- `docs/ROADMAP.md` - プロジェクト進捗
- `docs/PUBLIC_SITE_PLAN.md` - 公開サイト構築計画

### 設定

- `apps/*/wrangler.toml` - Cloudflare設定
- `apps/*/astro.config.mjs` - Astro設定
- `database/d1/migrations/` - D1マイグレーション

### スキーマ

- `database/schema_d1_full.sql` - 完全スキーマ定義

---

## ローカル開発

```bash
# Internal Site（管理画面）
cd apps/internal-site
npm run build
npm run dev:local
# → http://localhost:8788

# Public Site（公開サイト）
cd apps/public-site
npm run dev
# → http://localhost:4320
```

**注意**: `npm run dev` ではD1バインドが動作しません。API込みで動かす場合は `npm run build && npm run dev:local` を使用。

---

## デプロイ

- **Internal Site**: `main` ブランチへのpushで自動デプロイ
- **Public Site**: 
  - `develop` ブランチ → ステージング（自動）
  - `main` ブランチ → 本番（手動承認必要）

---

## 用語集

| 用語 | 説明 |
|------|------|
| D1 | Cloudflareのエッジデータベース（SQLite互換） |
| R2 | Cloudflareのオブジェクトストレージ（S3互換） |
| service_contents | 施術詳細ページ用のコンテンツ（FAQや特徴を含む） |
| treatment_before_afters | Before/After症例写真 |
| campaigns | キャンペーン情報（お知らせ、新サービス含む） |
| launches | 新商品導入プロジェクト管理 |

---

## 現在の進捗

- **Internal Site**: 80%完了
- **Public Site**: 90%完了（本番DNS切り替え待ち）
- **SEO**: 完了（sitemap, robots, JSON-LD）
