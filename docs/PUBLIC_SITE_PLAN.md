# 公開サイト構築計画

最終更新: 2025-12-27

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
| フレームワーク | Astro 5.x |
| ホスティング | Cloudflare Pages |
| データベース | Cloudflare D1（internal-siteと共有） |
| 画像ストレージ | Cloudflare R2（internal-siteと共有） |
| スタイリング | Tailwind CSS + カスタムCSS |
| 認証 | なし（公開サイト） |

---

## 進捗状況: **90%完了** 🎉

### ✅ Phase 1: 準備・設計（完了）

- [x] 現在の https://ledianclinic.jp/ のHTML/CSS/アセットを取得
- [x] データモデルの整理 → D1スキーマで対応可能
- [x] 画像・ロゴのダウンロード（120+ファイル）
- [x] フォント抽出（Noto Sans JP, Noto Serif JP）
- [x] カラーパレット抽出・設定

### ✅ Phase 2: ページ実装（完了）

| ページ | パス | 状態 |
|--------|------|------|
| トップページ | `/` | ✅ D1連携、Hero/SERVICE/POINT/PHOTO/ACCESS |
| サービス一覧 | `/service/` | ✅ カテゴリ別グループ化 |
| 施術詳細 | `/service/[slug]` | ✅ 動的ページ、料金・FAQ表示 |
| 料金表 | `/price/` | ✅ アコーディオンUI |
| 院長紹介 | `/doctor/` | ✅ 奥村先生に更新済み |
| おすすめ情報一覧 | `/news/` | ✅ タブフィルタ対応 |
| おすすめ情報詳細 | `/news/[slug]` | ✅ コンテンツ画像表示 |
| サブスクリプション | `/subscription/` | ✅ |
| お問い合わせ | `/contact/` | ✅ |
| 利用規約 | `/terms` | ✅ |
| プライバシーポリシー | `/privacy-policy` | ✅ |
| 特定商取引法 | `/legal` | ✅ |
| 施設利用規約 | `/use-terms` | ✅ |
| キャンセルポリシー | `/cancel` | ✅ |

### ✅ Phase 3: SEO・パフォーマンス（完了）

- [x] メタタグ最適化（title, description, OGP）
- [x] サイトマップ生成 (`/sitemap.xml` 動的生成)
- [x] robots.txt 設定（環境別対応）
- [x] 構造化データ（JSON-LD）
  - MedicalClinic / LocalBusiness
  - WebSite
  - BreadcrumbList
  - FAQPage（施術詳細）
  - NewsArticle（ニュース詳細）
  - MedicalProcedure（施術詳細）
- [x] OGP画像設置

### ✅ Phase 4: ステージングデプロイ（完了）

- [x] Cloudflare Pages で `public-site` をデプロイ
- [x] ステージング環境での動作確認
- [x] GitHub Actions CI/CD設定
- [x] ブランチ保護（main = 本番、develop = ステージング）

**ステージングURL:** https://develop.ledian-clinic-public.pages.dev

### ⏳ Phase 5: 本番公開（残タスク）

- [ ] `ledianclinic.jp` のDNSをCloudflareに向ける
- [ ] noindex解除（`PublicLayout.astro` の `noIndex` デフォルトを `false` に）
- [ ] robots.txt の本番モード確認
- [ ] SSL/TLS設定確認
- [ ] 最終QA

---

## 実装済みコンポーネント

### レイアウト・共通

| ファイル | 説明 |
|----------|------|
| `src/layouts/PublicLayout.astro` | ベースレイアウト（SEO対応） |
| `src/components/Header.astro` | ヘッダー（レスポンシブ） |
| `src/components/Footer.astro` | フッター |
| `src/components/FixedCTA.astro` | 固定CTA（モバイルアプリ風） |
| `src/components/CtaSection.astro` | 共通CTAセクション |

### SEOコンポーネント

| ファイル | 説明 |
|----------|------|
| `src/components/seo/JsonLd.astro` | JSON-LD汎用 |
| `src/components/seo/ClinicJsonLd.astro` | MedicalClinic構造化データ |
| `src/components/seo/BreadcrumbJsonLd.astro` | パンくずリスト |
| `src/components/seo/FaqJsonLd.astro` | FAQ構造化データ |
| `src/components/seo/ArticleJsonLd.astro` | ニュース記事 |
| `src/components/seo/ServiceJsonLd.astro` | 施術詳細 |

### スタイル

| ファイル | 説明 |
|----------|------|
| `src/styles/global.css` | グローバルスタイル・CSS変数 |
| `src/styles/page-common.css` | ページ共通スタイル |
| `src/styles/service.css` | サービス一覧ページ |
| `src/styles/price.css` | 料金ページ |

---

## アセット構成

```
public/
├── favicon.png
├── images/
│   ├── og-image.png          # OGP画像
│   ├── header-logo.svg
│   ├── footer-logo.svg
│   ├── hero/                  # ヒーロースライダー画像
│   ├── icons/                 # 各種アイコン
│   ├── points/                # 3つの魅力セクション
│   ├── photos/                # 店内写真
│   ├── theme/                 # 背景・バナー
│   ├── doctor/                # 院長写真
│   └── news/                  # ニュース画像
│       └── content/           # 記事内画像（slug別）
```

---

## 次のアクション（本番公開まで）

1. **DNS切り替え準備**
   - Cloudflare DNS設定確認
   - 旧サイトからのリダイレクト設定

2. **noindex解除**
   - `PublicLayout.astro` の `noIndex` デフォルトを `false` に変更

3. **最終QA**
   - 全ページの動作確認
   - レスポンシブ確認
   - SEO要素確認（Google Rich Results Test等）

---

## 関連ドキュメント

- [ROADMAP.md](./ROADMAP.md) - 全体の進捗
- [SEO_ROADMAP.md](./SEO_ROADMAP.md) - SEO/AIO対策詳細
- [DEPLOY_PUBLIC.md](./DEPLOY_PUBLIC.md) - デプロイ手順
- [D1_SINGLE_DB.md](./D1_SINGLE_DB.md) - D1設定詳細
