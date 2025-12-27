# ロードマップ

最終更新: 2025-12-27

このドキュメントは **プロジェクト全体の進捗と方向性**を示します。

---

## 現在のステータス

### ✅ Internal Site（管理サイト）- 80%完了

| 機能 | 進捗 | 備考 |
|------|------|------|
| 基盤構築 | ✅ 100% | Astro + D1 + Cloudflare Pages |
| 料金管理 | ✅ 100% | 一覧/新規/編集/インライン編集 |
| キャンペーン管理 | ✅ 95% | 一覧/作成/編集/種別フィルタ/本文編集 |
| 施術管理 | ✅ 90% | 詳細ページ/編集/料金連携 |
| 症例写真管理 | ✅ 90% | 一覧/編集/R2移行完了 |
| 新商品導入管理 | ✅ 80% | プロジェクト/タスク管理 |
| 画像/R2管理 | 🔄 50% | 移行完了、アップロードUI未 |
| データエクスポート | ⏳ 0% | - |
| 認証・認可 | ⏳ 0% | - |

**本番URL:** https://ledian-clinic-internal.pages.dev/

---

### ✅ Public Site（公開サイト）- 90%完了

| 機能 | 進捗 | 備考 |
|------|------|------|
| 基盤構築 | ✅ 100% | Astro + D1 + Tailwind |
| 画像・ロゴ | ✅ 100% | 120+ファイル取得済み |
| フォント・カラー | ✅ 100% | 現サイト完全コピー |
| トップページ | ✅ 100% | D1連携、Hero/SERVICE/POINT/PHOTO/ACCESS |
| サービス一覧 | ✅ 100% | カテゴリ別グループ化 |
| 施術詳細 | ✅ 100% | `/service/[slug]` 動的ページ |
| 料金表ページ | ✅ 100% | アコーディオンUI |
| 院長ページ | ✅ 100% | 奥村先生に更新済み |
| 固定ページ | ✅ 100% | 利用規約/プライバシー/特商法/施設規約/キャンセルポリシー |
| おすすめ情報 | ✅ 100% | 一覧（タブフィルタ）/詳細ページ |
| お問い合わせ | ✅ 100% | 地図・連絡先 |
| SEO対策 | ✅ 100% | sitemap/robots/JSON-LD/OGP |
| ステージングデプロイ | ✅ 100% | CI/CD設定完了 |
| 本番デプロイ | ⏳ 0% | DNS切り替え待ち |

**ステージングURL:** https://develop.ledian-clinic-public.pages.dev  
**本番予定:** https://ledianclinic.jp

---

## 本番公開までのロードマップ 🎯

### ✅ 完了済みフェーズ

| Phase | 内容 | 状態 |
|-------|------|------|
| Phase 1 | ページ実装（全14ページ） | ✅ 完了 |
| Phase 2 | SEO対策（sitemap/robots/JSON-LD） | ✅ 完了 |
| Phase 3 | ステージングデプロイ/CI/CD | ✅ 完了 |

### ⏳ 残りタスク（Phase 4: 本番公開）

| タスク | 優先度 | 状態 |
|--------|--------|------|
| DNS切り替え準備 | 🔴 高 | ⏳ |
| noindex解除 | 🔴 高 | ⏳ |
| 最終QA | 🔴 高 | ⏳ |
| 旧サイトリダイレクト設定 | 🟡 中 | ⏳ |

---

## 将来の機能拡張（Phase 5以降）

### 症例一覧ページ `/cases/`

- `treatment_before_afters` からBefore/After写真一覧
- カテゴリ別フィルタ
- 施術詳細との連携

### サービス検索・フィルタ機能

- 悩み軸（シミ、シワ、ニキビ等）で検索
- 部位軸（顔、体等）で検索

**必要なテーブル:**
```sql
-- 悩みマスタ
CREATE TABLE concerns (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE
);

-- 部位マスタ
CREATE TABLE body_parts (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE
);

-- サービス×悩み 中間テーブル
CREATE TABLE service_concerns (
  service_content_id TEXT REFERENCES service_contents(id),
  concern_id TEXT REFERENCES concerns(id),
  PRIMARY KEY (service_content_id, concern_id)
);

-- サービス×部位 中間テーブル
CREATE TABLE service_body_parts (
  service_content_id TEXT REFERENCES service_contents(id),
  body_part_id TEXT REFERENCES body_parts(id),
  PRIMARY KEY (service_content_id, body_part_id)
);
```

### Internal Site強化

- 画像アップロードUI
- データエクスポート（CSV/PDF）
- 認証・認可
- 操作ログ

---

## ディレクトリ構成

```
ledianclinic/
├── apps/
│   ├── internal-site/     # 管理サイト（CMS）
│   │   └── src/
│   └── public-site/       # 公開サイト
│       └── src/
├── database/
│   └── d1/
│       ├── migrations/    # D1マイグレーション
│       └── archive/       # 過去のワンオフスクリプト
├── docs/                  # ドキュメント
│   └── archive/           # アーカイブ済みドキュメント
├── data/                  # 静的データ（YAML/JSON）
└── scripts/               # ユーティリティスクリプト
```

---

## 関連ドキュメント

- [PUBLIC_SITE_PLAN.md](./PUBLIC_SITE_PLAN.md) - 公開サイト詳細
- [SEO_ROADMAP.md](./SEO_ROADMAP.md) - SEO/AIO対策
- [START.md](./START.md) - ローカル開発手順
- [INDEX.md](./INDEX.md) - ドキュメント一覧
