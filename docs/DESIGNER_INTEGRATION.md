# デザイナー向け統合ガイド

## 概要

外部フリーランスデザイナーが本番サイトを構築する際の統合ガイドです。

## システム構成

```
┌─────────────────┐
│  内部サイト      │  ← データ管理（Astro + D1）
│ (Internal Site) │      - メニュー・料金管理
│                 │      - キャンペーン管理
│                 │      - 症例写真管理
└────────┬────────┘
         │ API経由でデータ提供
         ↓
┌─────────────────┐
│  PostgreSQL DB  │  ← Gitで管理（スキーマ定義）
│                 │      - database/schema.sql
│                 │      - database/schema_content.sql
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   本番サイト     │  ← デザイナーが作成
│  (Public Site)  │      - APIからデータ取得
│                 │      - フロントエンド実装
└─────────────────┘
```

## デザイナーが知っておくべきこと

### 1. データソース

- **データベース**: PostgreSQL
- **スキーマ定義**: `database/schema.sql`, `database/schema_content.sql`
- **データ管理**: 内部サイト（Astro）で管理
- **API**: RESTful API経由でデータ取得

### 2. データ構造

主要なテーブル構造は `database/schema.sql` を参照してください。

**主要エンティティ:**
- Categories（カテゴリ）
- Subcategories（サブカテゴリ）
- Treatments（施術）
- Treatment Plans（料金プラン）
- Campaigns（キャンペーン）
- Before Afters（症例写真）

### 3. API仕様

詳細は [API仕様書](./API_FOR_DESIGNER.md) を参照してください。

### 4. Git管理

- スキーマ変更はGitで管理
- デザイナーはAPI仕様とスキーマ定義を参照
- 実際のデータは内部サイトで管理

## 必要なI/F（インターフェース）

### 1. RESTful API

#### 必須エンドポイント

- `GET /api/v1/categories` - カテゴリ一覧
- `GET /api/v1/treatments/{id}` - 施術詳細
- `GET /api/v1/plans` - 料金プラン一覧
- `GET /api/v1/campaigns` - キャンペーン一覧
- `GET /api/v1/before-afters` - 症例写真一覧

#### 認証方式

- API Key認証
- または Cloudflare Access経由

### 2. PostgreSQLスキーマ

- スキーマ定義ファイル（`database/schema.sql`）
- データ構造のドキュメント
- リレーションシップ図（必要に応じて）

### 3. サンプルデータ

- 開発・検証用のサンプルデータ
- データ投入スクリプト（`database/seed.sql`）

## 実装すべき機能

### Phase 1: 基本的なAPI

1. **カテゴリ・施術データ取得API**
   - カテゴリ一覧
   - サブカテゴリ一覧
   - 施術一覧
   - 施術詳細

2. **料金データ取得API**
   - 料金プラン一覧
   - フィルタリング（カテゴリ、施術、検索）

3. **キャンペーンデータ取得API**
   - アクティブなキャンペーン一覧
   - キャンペーン詳細

### Phase 2: 拡張機能

4. **症例写真API**
   - 症例写真一覧
   - フィルタリング（施術別）

5. **検索API**
   - 全文検索
   - カテゴリ・施術・料金の統合検索

### Phase 3: 高度な機能

6. **リアルタイム更新**
   - WebSocketまたはPolling
   - データ変更の通知

## デザイナーへの引き継ぎ資料

1. **API仕様書** (`docs/API_FOR_DESIGNER.md`)
2. **データ構造ドキュメント** (`database/schema.sql` の説明)
3. **サンプルコード** (JavaScript, Python等)
4. **認証情報** (API Key発行方法)
5. **テスト環境情報** (開発用APIエンドポイント)

## 技術スタック（デザイナー側）

デザイナーが使用する技術スタックは自由ですが、以下を推奨：

- **フロントエンド**: React, Vue, Next.js, Astro等
- **API**: RESTful API（JSON形式）
- **認証**: API Key または OAuth

## 質問・サポート

デザイナーからの質問は以下で受け付けます：
- GitHub Issues
- Slack / Discord（要設定）
- メール

