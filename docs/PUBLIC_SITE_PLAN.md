# 公開サイト構築計画

最終更新: 2024-12-27

## 概要

internal-site を CMS/管理画面として活用し、公開サイト（https://ledianclinic.jp/）を Cloudflare Pages + D1 で再構築する計画。

```
┌─────────────────────────────────────────────────────────┐
│                    Cloudflare D1                        │
│                   (共有データベース)                      │
│              ledian-internal-prod                        │
└────────────────────────┬────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         │                               │
         ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│   internal-site     │       │   public-site       │
│   (管理画面/CMS)     │       │  ledianclinic.jp    │
│                     │       │                     │
│ - 認証付き          │       │ - 一般公開          │
│ - CRUD操作          │       │ - 読み取り専用       │
│ - 画像アップロード   │       │ - SSR              │
│ - プレビュー機能     │       │ - SEO最適化         │
└─────────────────────┘       └─────────────────────┘
 ledian-clinic-internal        ledian-clinic-public
    .pages.dev                    .pages.dev
                                      ↓
                               ledianclinic.jp
```

## 技術スタック

| コンポーネント | 技術 |
|---------------|------|
| フレームワーク | Astro 4.x（internal-siteと統一） |
| ホスティング | Cloudflare Pages |
| データベース | Cloudflare D1（internal-siteと共有） |
| 画像ストレージ | Cloudflare R2（internal-siteと共有） |
| スタイリング | Tailwind CSS |
| 認証 | なし（公開サイト） |

---

## 進捗状況

### ✅ Phase 1: 準備・設計（完了）

- [x] 現在の https://ledianclinic.jp/ のHTML/CSS/アセットを取得
- [x] データモデルの整理 → D1スキーマで対応可能
- [x] 画像・ロゴのダウンロード（37ファイル）
- [x] フォント抽出（Noto Sans JP, Noto Serif JP）
- [x] カラーパレット抽出・設定

**成果物:**
- ✅ ダウンロード済み画像: `apps/public-site/public/images/`
- ✅ フォント設定: `apps/public-site/src/styles/global.css`
- ✅ Tailwind設定: `apps/public-site/tailwind.config.mjs`

### ✅ Phase 2: 公開サイト構築（60%完了）

- [x] `apps/public-site` ディレクトリ作成
- [x] Astro プロジェクト初期化
- [x] `wrangler.toml` でD1/R2バインディング設定
- [x] ページコンポーネント実装
  - [x] トップページ（ヒーロー、サービス、ポイント、写真）
  - [x] 施術一覧（カテゴリ別表示）
  - [x] 料金表（アコーディオンUI）
  - [ ] 施術詳細 `/service/[slug]`
  - [ ] キャンペーン一覧・詳細 `/news/`
  - [ ] アクセス・クリニック情報
  - [ ] お問い合わせ
- [x] 既存デザインの再現（HTML/CSS）
- [x] レスポンシブ対応
- [x] ヘッダー・フッター・固定CTAコンポーネント

**成果物:**
- ✅ 動作するローカル開発環境: http://localhost:4321/

### ⏳ Phase 3: SEO・パフォーマンス（未着手）

- [ ] メタタグ最適化（title, description, OGP）
- [ ] サイトマップ生成 (`sitemap.xml`)
- [ ] robots.txt 設定
- [ ] 構造化データ（JSON-LD）
- [ ] 画像最適化（WebP変換、lazy loading）
- [ ] キャッシュ戦略の実装

### ⏳ Phase 4: デプロイ・DNS設定（未着手）

- [ ] Cloudflare Pages で `public-site` をデプロイ
- [ ] ステージング環境での動作確認
- [ ] `ledianclinic.jp` のDNSをCloudflareに向ける
- [ ] 本番D1への接続確認
- [ ] SSL/TLS設定確認

### ⏳ Phase 5: 運用開始（未着手）

- [ ] テスト・QA
- [ ] パフォーマンス監視設定
- [ ] 運用マニュアル作成

---

## 実装済みファイル一覧

### ページ

| パス | ファイル | 状態 |
|------|----------|------|
| `/` | `src/pages/index.astro` | ✅ |
| `/service/` | `src/pages/service/index.astro` | ✅ |
| `/price/` | `src/pages/price/index.astro` | ✅ |
| `/service/[slug]` | - | ⏳ |
| `/news/` | - | ⏳ |
| `/news/[slug]` | - | ⏳ |

### コンポーネント

| ファイル | 説明 | 状態 |
|----------|------|------|
| `src/layouts/PublicLayout.astro` | ベースレイアウト | ✅ |
| `src/components/Header.astro` | ヘッダー（レスポンシブ対応） | ✅ |
| `src/components/Footer.astro` | フッター | ✅ |
| `src/components/FixedCTA.astro` | 固定CTA（モバイル用） | ✅ |

### スタイル

| ファイル | 説明 | 状態 |
|----------|------|------|
| `src/styles/global.css` | グローバルスタイル・変数 | ✅ |
| `tailwind.config.mjs` | Tailwind設定 | ✅ |

### アセット（37ファイル）

```
public/images/
├── header-logo.svg      # ヘッダーロゴ
├── header-menu.svg      # メニューアイコン
├── header-close.svg     # 閉じるアイコン
├── footer-logo.svg      # フッターロゴ
├── icons/
│   ├── footer-line.svg
│   ├── footer-x.svg
│   ├── footer-instagram.svg
│   ├── cta-instagram.png
│   ├── cta-arrow-w.svg
│   ├── cta-arrow-b.svg
│   └── service-arrow.svg
├── theme/
│   ├── hero-bg.svg
│   ├── front-banner.png
│   └── subscription-banner.jpg
├── points/
│   ├── point-title-miryoku.svg
│   ├── point01.svg - point03.svg
│   └── point-img01.png - point-img03.png
├── photos/
│   └── clinic-01.png - clinic-04.png
└── slider/
    ├── slider-pc-01.png - slider-pc-03.png
    └── slider-sp-01.png - slider-sp-03.png
```

---

## 設定ファイル

### wrangler.toml

```toml
name = "ledian-clinic-public"
compatibility_date = "2025-01-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = "./dist"

[[d1_databases]]
binding = "DB"
database_name = "ledian-internal-prod"
database_id = "bcf4e5f4-1528-4b8b-b30b-47bd9b99d6b3"
migrations_dir = "../../database/d1/migrations"

[[r2_buckets]]
binding = "STORAGE"
bucket_name = "ledian-assets"
```

### astro.config.mjs

```javascript
import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  output: 'server',
  adapter: cloudflare({
    platformProxy: {
      enabled: true,
      persist: true,
      persistTo: '../../.wrangler/state/v3/d1'
    }
  }),
  integrations: [tailwind()]
});
```

---

## D1クエリ例

### 施術一覧

```sql
SELECT 
  t.id, t.name, t.slug,
  sc.name as subcategory_name
FROM treatments t
JOIN subcategories sc ON t.subcategory_id = sc.id
WHERE t.is_active = 1 AND sc.is_active = 1
ORDER BY sc.sort_order, t.sort_order
```

### 料金表

```sql
SELECT 
  pg.id, pg.name as group_name,
  pi.id as item_id, pi.name as item_name,
  pi.price, pi.price_text, pi.notes
FROM price_groups pg
LEFT JOIN price_items pi ON pg.id = pi.group_id
WHERE pg.is_active = 1
ORDER BY pg.sort_order, pi.sort_order
```

### キャンペーン

```sql
SELECT id, title, slug, description, image_url, start_date
FROM campaigns
WHERE is_published = 1
ORDER BY start_date DESC
LIMIT 4
```

---

## 次のアクション

1. **施術詳細ページ** `/service/[slug]` の実装
2. **キャンペーンページ** `/news/` の実装
3. **SEO対策**（メタタグ、サイトマップ）
4. **ステージングデプロイ**
5. **本番DNS切り替え**

---

## 関連ドキュメント

- [ロードマップ](./ROADMAP.md) - 全体の進捗
- [公開サイトデプロイ手順](./DEPLOY_PUBLIC.md) - デプロイ方法
- [アプリ構成](./apps-structure.md) - 2サイト運用の基本方針
- [D1データベース設定](./D1_SINGLE_DB.md) - D1の設定詳細
