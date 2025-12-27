# Ledian Clinic プロジェクト ドキュメント

最終更新: 2025-12-27

## 🚀 クイックスタート

| ドキュメント | 説明 |
|-------------|------|
| [START.md](./START.md) | ローカル環境での起動手順 |
| [ROADMAP.md](./ROADMAP.md) | プロジェクト全体の進捗とロードマップ |

---

## 📱 アプリケーション

### Public Site（公開サイト）

| ドキュメント | 説明 |
|-------------|------|
| [PUBLIC_SITE_PLAN.md](./PUBLIC_SITE_PLAN.md) | 公開サイトの構築計画と進捗 |
| [DEPLOY_PUBLIC.md](./DEPLOY_PUBLIC.md) | 公開サイトのデプロイ手順 |
| [SEO_ROADMAP.md](./SEO_ROADMAP.md) | SEO/AIO/LLMO対策ロードマップ |

**ステージングURL:** https://develop.ledian-clinic-public.pages.dev  
**本番URL:** https://ledianclinic.jp (DNS切り替え待ち)

### Internal Site（管理サイト）

| ドキュメント | 説明 |
|-------------|------|
| [INTERNAL_SITE_PURPOSE.md](./INTERNAL_SITE_PURPOSE.md) | 管理サイトの目的と機能 |
| [INTERNAL_SITE_CONFIG.md](./INTERNAL_SITE_CONFIG.md) | 設定と環境変数 |
| [DEPLOY_INTERNAL.md](./DEPLOY_INTERNAL.md) | 管理サイトのデプロイ手順 |

**本番URL:** https://ledian-clinic-internal.pages.dev

---

## 🗄️ データベース / D1

| ドキュメント | 説明 |
|-------------|------|
| [D1_ENVIRONMENT.md](./D1_ENVIRONMENT.md) | D1環境とバインディング設定 |
| [D1_SINGLE_DB.md](./D1_SINGLE_DB.md) | 単一DB構成の説明 |
| [database/d1/README.md](../database/d1/README.md) | マイグレーション手順 |
| [SCHEMA_UNIFICATION.md](./SCHEMA_UNIFICATION.md) | スキーマ統一方針 |
| [seed-and-sync.md](./seed-and-sync.md) | データ投入・同期フロー |

**スキーマ定義:** `database/schema_d1_full.sql`  
**マイグレーション:** `database/d1/migrations/`

---

## 🚢 デプロイ / インフラ

| ドキュメント | 説明 |
|-------------|------|
| [ci-deploy.md](./ci-deploy.md) | GitHub ActionsによるCI/CD |
| [infra-cloudflare.md](./infra-cloudflare.md) | Cloudflareインフラ構成 |

---

## 🔌 API / 連携

| ドキュメント | 説明 |
|-------------|------|
| [API_FOR_DESIGNER.md](./API_FOR_DESIGNER.md) | デザイナー向けAPIリファレンス |
| [DESIGNER_INTEGRATION.md](./DESIGNER_INTEGRATION.md) | デザイナー連携ガイド |
| [API_IMPLEMENTATION_PLAN.md](./API_IMPLEMENTATION_PLAN.md) | API実装計画 |

---

## 🔧 トラブルシューティング

| ドキュメント | 説明 |
|-------------|------|
| [DEBUG_API.md](./DEBUG_API.md) | APIデバッグ手順 |
| [TROUBLESHOOTING_CAMPAIGNS.md](./TROUBLESHOOTING_CAMPAIGNS.md) | キャンペーン関連の問題解決 |
| [node-upgrade-guide.md](./node-upgrade-guide.md) | Node.jsアップグレード手順 |

---

## 📐 アーキテクチャ

| ドキュメント | 説明 |
|-------------|------|
| [apps-structure.md](./apps-structure.md) | アプリケーション構成 |
| [directory-structure.md](./directory-structure.md) | ディレクトリ構造 |
| [campaign-schema.md](./campaign-schema.md) | キャンペーンスキーマ |

---

## 📝 その他

| ドキュメント | 説明 |
|-------------|------|
| [AI.md](./AI.md) | AI向けコンテキスト・用語集 |

---

## 📦 アーカイブ

過去の計画や廃止されたドキュメントは `docs/archive/` に移動しました。

```
docs/archive/
├── ARCHIVE.md              # 廃止ドキュメント一覧
├── COMPREHENSIVE_ROADMAP.md # 包括的ロードマップ（旧）
├── DATA_NORMALIZATION_ROADMAP.md
├── HOW_TO_START.md         # → START.mdに統合
├── QUICK_START.md          # → START.mdに統合
├── NEXT_WEEK.md
├── TRAINING_FEATURE_PROPOSAL.md
├── artifact-roadmap.md
├── frontend-current-state.md
├── internal-site-progress.md
├── local-dev-guide.md      # → START.mdに統合
├── local-development-setup.md
└── tasks.md
```
