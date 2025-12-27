# 公開サイト（Public Site）デプロイ手順

最終更新: 2024-12-27

## 概要

`apps/public-site` を Cloudflare Pages にデプロイし、`ledianclinic.jp` として公開する手順。

---

## 前提条件

- Node.js 20.x 以上
- Cloudflare アカウント
- Wrangler CLI がインストール済み
- D1データベース `ledian-internal-prod` が本番環境に存在

---

## ローカル開発

### 1. 開発サーバー起動

```bash
cd apps/public-site
npm install
npm run dev
```

ブラウザで http://localhost:4321 にアクセス

### 2. ローカルD1の確認

ローカル開発では `internal-site` と同じD1データベースを共有しています。
データがない場合は `internal-site` 側でマイグレーションを実行してください。

```bash
cd apps/internal-site
npx wrangler d1 migrations apply ledian-internal-prod --local
```

---

## ステージングデプロイ

### 1. ビルド

```bash
cd apps/public-site
npm run build
```

### 2. プレビューデプロイ

```bash
cd apps/public-site
npx wrangler pages deploy dist --project-name ledian-clinic-public
```

初回実行時はプロジェクト作成を求められます。

### 3. プレビューURLで確認

デプロイ完了後、以下のようなURLが発行されます：
```
https://<commit-hash>.ledian-clinic-public.pages.dev
```

---

## 本番デプロイ

### 1. Cloudflare Dashboard での設定

1. [Cloudflare Dashboard](https://dash.cloudflare.com/) にログイン
2. Pages → `ledian-clinic-public` を選択
3. Settings → Environment variables で以下を確認：
   - D1バインディングが設定されている
   - R2バインディングが設定されている

### 2. 本番ビルド & デプロイ

```bash
cd apps/public-site
npm run build
npx wrangler pages deploy dist --project-name ledian-clinic-public --branch main
```

### 3. 動作確認

本番URL: `https://ledian-clinic-public.pages.dev`

---

## カスタムドメイン設定（ledianclinic.jp）

### 1. Cloudflare DNS 設定

1. Cloudflare Dashboard → DNS → Records
2. 以下のレコードを追加/更新：

```
Type: CNAME
Name: @
Target: ledian-clinic-public.pages.dev
Proxy status: Proxied
```

または

```
Type: CNAME
Name: www
Target: ledian-clinic-public.pages.dev
Proxy status: Proxied
```

### 2. Pages でカスタムドメインを追加

1. Pages → `ledian-clinic-public` → Custom domains
2. 「Set up a custom domain」をクリック
3. `ledianclinic.jp` を入力
4. DNS設定を確認して「Activate domain」

### 3. SSL/TLS 設定

1. Cloudflare Dashboard → SSL/TLS
2. 暗号化モード: 「Full (strict)」を選択
3. Edge Certificates が有効になっていることを確認

---

## D1バインディング設定（Cloudflare Dashboard）

### Pages 設定

1. Pages → `ledian-clinic-public` → Settings → Functions
2. D1 database bindings:
   - Variable name: `DB`
   - D1 database: `ledian-internal-prod`
3. R2 bucket bindings:
   - Variable name: `STORAGE`
   - R2 bucket: `ledian-assets`

---

## トラブルシューティング

### D1接続エラー

**症状:** `D1_ERROR: no such table` が発生

**対処:**
1. Cloudflare Dashboard でD1バインディングが正しく設定されているか確認
2. 本番D1でマイグレーションが実行されているか確認：
   ```bash
   npx wrangler d1 migrations list ledian-internal-prod --remote
   ```

### 画像が表示されない

**症状:** R2の画像が404

**対処:**
1. R2バケットのパブリックアクセスが有効か確認
2. 画像URLが正しいか確認（`https://pub-xxx.r2.dev/...`）

### ビルドエラー

**症状:** Astro ビルドが失敗

**対処:**
```bash
# キャッシュクリア
rm -rf node_modules .astro dist
npm install
npm run build
```

---

## CI/CD 設定（オプション）

### GitHub Actions

```yaml
# .github/workflows/deploy-public.yml
name: Deploy Public Site

on:
  push:
    branches: [main]
    paths:
      - 'apps/public-site/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: |
          cd apps/public-site
          npm ci
          
      - name: Build
        run: |
          cd apps/public-site
          npm run build
          
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: ledian-clinic-public
          directory: apps/public-site/dist
```

### 必要なSecrets

- `CLOUDFLARE_API_TOKEN`: Cloudflare API Token（Pages権限付き）
- `CLOUDFLARE_ACCOUNT_ID`: Cloudflare アカウントID

---

## チェックリスト

### デプロイ前

- [ ] ローカルで全ページの動作確認
- [ ] ビルドエラーがないこと
- [ ] D1からデータが正常に取得できること
- [ ] レスポンシブ表示の確認

### デプロイ後

- [ ] 本番URLでアクセス可能
- [ ] 全ページが正常に表示
- [ ] 画像が正常に表示
- [ ] モバイル表示の確認
- [ ] SSL/HTTPS が有効

### DNS切り替え後

- [ ] `ledianclinic.jp` でアクセス可能
- [ ] 旧サイトからのリダイレクト確認（必要に応じて）
- [ ] Google Search Console での確認
- [ ] SEO（メタタグ、サイトマップ）の確認

---

## 関連ドキュメント

- [ロードマップ](./ROADMAP.md)
- [公開サイト構築計画](./PUBLIC_SITE_PLAN.md)
- [内部サイトデプロイ](./DEPLOY_INTERNAL.md)
- [D1データベース設定](./D1_SINGLE_DB.md)

