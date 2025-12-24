# GitHub Actions ワークフロー

## Internal Site デプロイ

### 手動デプロイの実行方法

1. GitHubリポジトリの「Actions」タブに移動
2. 左サイドバーから「Deploy Internal Site to Production」を選択
3. 「Run workflow」ボタンをクリック
4. 確認入力欄に `deploy` と入力
5. 「Run workflow」ボタンをクリックして実行

### 必要なシークレット設定

GitHubリポジトリの Settings → Secrets and variables → Actions で以下を設定してください：

- `CLOUDFLARE_API_TOKEN`: Cloudflare APIトークン（Pages/D1権限が必要）
- `CLOUDFLARE_ACCOUNT_ID`: CloudflareアカウントID（オプション、wrangler.tomlに設定されている場合は不要）

### APIトークンの取得方法

1. Cloudflare Dashboard → My Profile → API Tokens
2. 「Create Token」をクリック
3. 「Edit Cloudflare Workers」テンプレートを選択
4. 権限を設定：
   - Account: Cloudflare Pages: Edit
   - Account: Workers Scripts: Edit
   - Account: D1: Edit
5. トークンを生成してGitHubシークレットに設定

### 注意事項

- このワークフローは手動でのみ実行されます（自動デプロイは行われません）
- デプロイ前に必ずローカルで動作確認を行ってください
- 本番環境のデータベースに影響する操作は慎重に行ってください

