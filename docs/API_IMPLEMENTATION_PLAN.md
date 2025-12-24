# API実装計画（デザイナー向けI/F）

## 目的

外部フリーランスデザイナーが本番サイトを構築する際に使用するAPIを実装します。

## 実装方針

### 1. 内部サイト（Astro）のAPIを拡張

現在の内部サイトのAPI（`apps/internal-site/src/pages/api/`）をベースに、デザイナー向けの公開APIを作成します。

### 2. APIバージョニング

```
/api/v1/categories
/api/v1/treatments
/api/v1/plans
...
```

### 3. 認証方式

- **API Key認証**: デザイナー用のAPI Keyを発行
- **Cloudflare Access**: 必要に応じて

### 4. データソース

- **開発環境**: D1（内部サイトと同じ）
- **本番環境**: PostgreSQL（デザイナーがアクセス）

## 実装するエンドポイント

### 必須（Phase 1）

1. `GET /api/v1/categories` - カテゴリ一覧
2. `GET /api/v1/subcategories?category_id={id}` - サブカテゴリ一覧
3. `GET /api/v1/treatments?subcategory_id={id}` - 施術一覧
4. `GET /api/v1/treatments/{id}` - 施術詳細
5. `GET /api/v1/plans` - 料金プラン一覧（フィルタリング対応）
6. `GET /api/v1/campaigns?is_active=true` - アクティブなキャンペーン一覧

### 拡張（Phase 2）

7. `GET /api/v1/before-afters?treatment_id={id}` - 症例写真一覧
8. `GET /api/v1/search?q={keyword}` - 統合検索
9. `GET /api/v1/faqs?treatment_id={id}` - FAQ一覧

## 実装場所

### オプション1: 内部サイト内に追加

```
apps/internal-site/src/pages/api/v1/
├── categories.ts
├── treatments.ts
├── treatments/[id].ts
├── plans.ts
├── campaigns.ts
└── before-afters.ts
```

### オプション2: 別プロジェクトとして分離

```
apps/public-api/  (新規作成)
├── src/
│   └── pages/
│       └── api/
│           └── v1/
│               ├── categories.ts
│               └── ...
```

**推奨**: オプション1（内部サイト内に追加）
- 同じデータソース（D1）を使用
- コードの重複を避ける
- 管理が簡単

## 認証実装

### API Key認証

```typescript
// apps/internal-site/src/middleware/api-auth.ts
export function verifyApiKey(request: Request): boolean {
  const apiKey = request.headers.get('Authorization')?.replace('Bearer ', '');
  const validApiKeys = ['key1', 'key2']; // 環境変数から取得
  return validApiKeys.includes(apiKey || '');
}
```

### 環境変数

```bash
API_KEYS=key1,key2,key3
```

## PostgreSQL連携

### 現状

- 内部サイト: D1（SQLite互換）
- 本番: PostgreSQL（デザイナーがアクセス）

### 対応方法

1. **データ同期**: D1 → PostgreSQL への同期処理
2. **API実装**: PostgreSQLを直接参照するAPIエンドポイント
3. **データ変換**: D1とPostgreSQLのデータ構造の差異を吸収

### 推奨アプローチ

**Phase 1**: 内部サイトのAPIをそのまま使用（D1経由）
- 開発が早い
- デザイナーは即座にAPIを使用可能

**Phase 2**: PostgreSQL連携APIを追加
- 本番環境用のAPIエンドポイント
- D1とPostgreSQLの両方をサポート

## ドキュメント作成

1. **API仕様書** (`docs/API_FOR_DESIGNER.md`) ✅ 作成済み
2. **統合ガイド** (`docs/DESIGNER_INTEGRATION.md`) ✅ 作成済み
3. **PostgreSQLスキーマドキュメント** (要作成)
4. **サンプルコード集** (要作成)

## 実装スケジュール

### 即座に実装可能

- `GET /api/v1/categories` - 既存の`/api/categories`をベースに拡張
- `GET /api/v1/plans` - 既存の`/api/pricing`をベースに拡張

### 要実装

- API Key認証の追加
- バージョニング（`/api/v1/`プレフィックス）
- エラーハンドリングの統一
- レスポンス形式の統一

## 次のステップ

1. API Key認証機能の実装
2. `/api/v1/`エンドポイントの作成
3. PostgreSQLスキーマドキュメントの作成
4. サンプルコードの作成



