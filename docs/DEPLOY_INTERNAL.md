# 内部サイト（Internal）デプロイ手順

## 本番環境へのデプロイ

### 1. ビルド

```bash
cd apps/internal-site
npm run build
```

### 2. デプロイ（初回または更新）

```bash
cd apps/internal-site
wrangler pages deploy dist
```

### 3. プレビュー（デプロイ前の確認）

デプロイする前に、ローカルで本番環境と同じ設定で確認：

```bash
cd apps/internal-site
npm run build
wrangler pages dev dist --local --port 8788
```

ブラウザで http://localhost:8788 にアクセス

### 4. 本番URLの確認

デプロイ後、以下のコマンドでURLを確認：

```bash
wrangler pages deployment list
```

または、Cloudflare Dashboardで確認：
- https://dash.cloudflare.com/ → Pages → `ledian-clinic-internal`

## 環境

- **本番URL**: `https://ledian-clinic-internal.pages.dev`（仮）
- **プレビューURL**: PR/ブランチごとに自動生成される

## 認証

本番環境はCloudflare Accessで保護されているため、アクセスには認証が必要です。

## 注意事項

- デプロイ前に必ずローカルで動作確認
- マイグレーションとデータ投入は別途実行が必要
- 本番環境のデータベースに影響するため、慎重に操作

