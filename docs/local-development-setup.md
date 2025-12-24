# ローカル開発環境セットアップ

## 📋 現在の状況

**リモート（production）**: ✅ マイグレーション適用済み  
**ローカル開発環境**: ⚠️ 未設定

## 🔧 ローカル開発環境のセットアップ方法

### 方法1: ローカルD1データベースを作成

```bash
# ローカルD1データベースを作成
npx wrangler@4.56.0 d1 create ledian-internal-local \
  --config wrangler.internal.toml \
  --local

# マイグレーションをローカルに適用
npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod \
  --config wrangler.internal.toml \
  --local
```

### 方法2: wrangler pages dev を使用（推奨）

ローカル開発では、`wrangler pages dev` を使用してローカルD1を参照します。

```bash
cd apps/internal-site

# 開発サーバー起動（ローカルD1を参照）
npx wrangler@4.56.0 pages dev dist --local
```

**注意**: Astroの`npm run dev`では、Pages FunctionsのD1バインドは動作しません。`wrangler pages dev`を使用する必要があります。

### 方法3: Astro開発サーバー + モックAPI（開発中）

現在、`npm run dev`（Astro開発サーバー）を使用していますが、これは静的サイトとして動作し、D1バインドは使用できません。

## 🎯 推奨ワークフロー

### 開発フェーズ

1. **コード編集**: Astro開発サーバー（`npm run dev`）でUI確認
2. **API動作確認**: `wrangler pages dev`でD1統合を確認
3. **デプロイ前テスト**: `npm run build` → `wrangler pages dev dist`

### 現在の制限事項

- `npm run dev`（Astro開発サーバー）ではD1は使用できない
- API Routesは`wrangler pages dev`でのみ動作
- ローカルD1データベースは別途作成が必要

## 📝 次のステップ

1. ローカルD1データベースを作成（必要に応じて）
2. `wrangler pages dev`での開発ワークフローを確立
3. または、モックデータを使用した開発環境を構築

