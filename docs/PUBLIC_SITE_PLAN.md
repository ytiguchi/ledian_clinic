# 公開サイト構築計画

## 概要

internal-site を CMS/管理画面として活用し、公開サイト（https://ledianclinic.jp/）を Cloudflare Pages + D1 で再構築する計画。

```
┌─────────────────────────────────────────────────────────┐
│                    Cloudflare D1                        │
│                   (共有データベース)                      │
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
│ - 画像アップロード   │       │ - SSR/SSG           │
│ - プレビュー機能     │       │ - SEO最適化         │
└─────────────────────┘       └─────────────────────┘
    admin.ledianclinic.jp         ledianclinic.jp
```

## 技術スタック

| コンポーネント | 技術 |
|---------------|------|
| フレームワーク | Astro（internal-siteと統一） |
| ホスティング | Cloudflare Pages |
| データベース | Cloudflare D1（internal-siteと共有） |
| 画像ストレージ | Cloudflare R2（internal-siteと共有） |
| 認証 | なし（公開サイト） |
| キャッシュ | Cloudflare KV または Cache API |

## 実現可能性

| 項目 | 評価 |
|------|------|
| 技術的実現性 | ⭐⭐⭐⭐⭐ 完全に可能 |
| 工数見積もり | 4-6週間（フルタイム1人） |
| 運用メリット | ⭐⭐⭐⭐⭐ 大きい |
| リスク | ⭐⭐（低〜中） |

---

## マイルストーン

### Phase 1: 準備・設計（1週間）

- [ ] 現在の https://ledianclinic.jp/ のHTML/CSS/アセットを取得
- [ ] データモデルの整理（施術、料金、キャンペーン等がD1に揃っているか確認）
- [ ] 公開サイト用のAPIエンドポイント設計
- [ ] ページ一覧・URL設計

**成果物:**
- ページ構成図
- 必要なデータ項目リスト
- API設計書

### Phase 2: 公開サイト構築（2-3週間）

- [ ] `apps/public-site` ディレクトリを新規作成
- [ ] Astro プロジェクト初期化
- [ ] `wrangler.jsonc` でD1/R2バインディングを共有設定
- [ ] ページコンポーネント実装
  - [ ] トップページ
  - [ ] 施術一覧・詳細
  - [ ] 料金表
  - [ ] キャンペーン
  - [ ] アクセス・クリニック情報
  - [ ] お知らせ一覧
- [ ] 既存デザインの再現（HTML/CSS移植）
- [ ] レスポンシブ対応

**成果物:**
- 動作する公開サイト（ローカル）

### Phase 3: DB共有設定・API整備（1週間）

- [ ] 公開サイト専用の読み取りAPIを整備（または直接D1クエリ）
- [ ] `is_published` フラグによるフィルタリング実装
- [ ] キャッシュ戦略の実装
  - 静的ページ: ビルド時生成（SSG）
  - 動的ページ: KVキャッシュまたはISR
- [ ] 画像最適化（Cloudflare Images または R2 + Transform）

**成果物:**
- パフォーマンス最適化済みサイト

### Phase 4: デプロイ・DNS設定（数日）

- [ ] Cloudflare Pages で `public-site` をデプロイ
- [ ] ステージング環境での動作確認
- [ ] `ledianclinic.jp` のDNSをCloudflareに向ける
- [ ] 本番D1への切り替え
- [ ] SSL/TLS設定確認

**成果物:**
- 本番デプロイ完了

### Phase 5: コンテンツ移行・運用開始（1週間）

- [ ] 既存コンテンツをD1に登録（管理画面から）
- [ ] テスト・QA
- [ ] SEO確認（メタタグ、OGP、サイトマップ）
- [ ] 旧サイトからの完全移行
- [ ] 運用マニュアル作成

**成果物:**
- 運用中の公開サイト

---

## 障壁と対策

| 障壁 | リスク | 対策 |
|------|--------|------|
| D1の同時接続制限 | 中 | 公開サイトはSSGまたはKVキャッシュで負荷軽減 |
| 認証の分離 | 低 | internal-siteのみ認証ミドルウェア適用（既存） |
| デザイン再現 | 中 | 既存HTML/CSSをそのまま活用可能 |
| SEO維持 | 中 | メタタグ、OGP、サイトマップを管理画面から編集可能に |
| 画像配信 | 低 | R2バケットを両サイトで共有 |
| 既存データ移行 | 中 | CSVインポート機能を管理画面に追加 |

---

## 技術的な実装詳細

### ディレクトリ構成

```
apps/
├── internal-site/          # 管理画面（既存）
│   ├── src/
│   │   ├── pages/
│   │   │   ├── api/        # CRUD API
│   │   │   ├── pricing/
│   │   │   ├── treatments/
│   │   │   └── ...
│   │   └── components/
│   └── wrangler.jsonc
│
└── public-site/            # 公開サイト（新規）
    ├── src/
    │   ├── pages/
    │   │   ├── index.astro
    │   │   ├── treatments/
    │   │   ├── price/
    │   │   └── ...
    │   ├── components/
    │   └── layouts/
    ├── public/
    │   └── assets/
    └── wrangler.jsonc
```

### D1共有設定

`apps/public-site/wrangler.jsonc`:
```jsonc
{
  "name": "ledian-public",
  "pages_build_output_dir": "./dist",
  "compatibility_flags": ["nodejs_compat"],
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "ledian-clinic-db",
      "database_id": "xxx-xxx-xxx"  // internal-siteと同じID
    }
  ],
  "r2_buckets": [
    {
      "binding": "STORAGE",
      "bucket_name": "ledian-assets"
    }
  ]
}
```

### ページ実装例

```astro
---
// apps/public-site/src/pages/treatments/index.astro
import Layout from '../../layouts/Layout.astro';

const db = Astro.locals.runtime.env.DB;

const { results: treatments } = await db.prepare(`
  SELECT 
    t.id,
    t.name,
    t.slug,
    t.description,
    t.thumbnail_url,
    c.name as category_name,
    sc.name as subcategory_name
  FROM treatments t
  JOIN subcategories sc ON t.subcategory_id = sc.id
  JOIN categories c ON sc.category_id = c.id
  WHERE t.is_published = 1
  ORDER BY c.sort_order, sc.sort_order, t.sort_order
`).all();
---

<Layout title="施術一覧 | Ledian Clinic">
  <section class="treatments-list">
    {treatments.map(treatment => (
      <a href={`/treatments/${treatment.slug}`} class="treatment-card">
        <img src={treatment.thumbnail_url} alt={treatment.name} />
        <h3>{treatment.name}</h3>
        <p>{treatment.description}</p>
      </a>
    ))}
  </section>
</Layout>
```

### 公開/非公開フィルタリング

管理画面で `is_published` フラグを設定し、公開サイトでは `WHERE is_published = 1` でフィルタリング。

```sql
-- 公開サイトでのクエリ例
SELECT * FROM treatments WHERE is_published = 1;
SELECT * FROM campaigns WHERE is_active = 1 AND start_date <= date('now') AND end_date >= date('now');
```

---

## 運用フロー

### コンテンツ更新フロー

```
1. 管理者がinternal-siteにログイン
2. 施術/料金/キャンペーン等を編集
3. 「公開」ボタンで is_published = 1 に設定
4. 公開サイトに即時反映（SSR）または次回ビルド時反映（SSG）
```

### デプロイフロー

```
GitHub Push
    │
    ├── internal-site (admin.ledianclinic.jp)
    │   └── Cloudflare Pages (自動デプロイ)
    │
    └── public-site (ledianclinic.jp)
        └── Cloudflare Pages (自動デプロイ)
```

---

## 必要なスキーマ拡張（検討）

公開サイト運用に向けて、以下のフィールド追加を検討：

| テーブル | フィールド | 説明 |
|----------|-----------|------|
| treatments | `slug` | URL用スラッグ |
| treatments | `meta_title` | SEOタイトル |
| treatments | `meta_description` | SEO説明文 |
| treatments | `og_image_url` | OGP画像 |
| categories | `slug` | URL用スラッグ |
| subcategories | `slug` | URL用スラッグ |
| pages | 新規テーブル | 固定ページ管理 |
| site_settings | 新規テーブル | サイト設定（ロゴ、連絡先等） |

---

## 関連ドキュメント

- [アプリ構成](./apps-structure.md) - 2サイト運用の基本方針
- [D1データベース設定](./D1_SINGLE_DB.md) - D1の設定詳細
- [デプロイ手順](./DEPLOY_INTERNAL.md) - デプロイ方法
- [スキーマ拡張計画](./SCHEMA_EXTENSION_PLAN.md) - 今後の拡張計画

