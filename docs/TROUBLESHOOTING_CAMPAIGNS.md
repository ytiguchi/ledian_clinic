# キャンペーン管理ページのトラブルシューティング

## 問題

「キャンペーンの読み込みに失敗しました」というエラーが表示される

## 確認事項

### 1. テーブルの存在確認

```bash
cd apps/internal-site
source ~/.nvm/nvm.sh
nvm use 20
wrangler d1 execute ledian-internal-prod --local --command "SELECT name FROM sqlite_master WHERE type='table' AND name='campaigns';"
```

### 2. マイグレーションの適用確認

```bash
cd apps/internal-site
wrangler d1 execute ledian-internal-prod --local --file ../../database/d1/migrations/003_add_campaigns.sql
```

### 3. APIエンドポイントの確認

```bash
curl http://localhost:8788/api/campaigns
```

期待されるレスポンス:
```json
{
  "campaigns": []
}
```

または:

```json
{
  "error": "Internal Server Error",
  "message": "..."
}
```

### 4. ブラウザのコンソールを確認

開発者ツール（F12）を開いて、コンソールタブでエラーメッセージを確認してください。

### 5. wrangler pages dev のログを確認

ターミナルで `wrangler pages dev` を実行している場合は、エラーメッセージが表示されます。

## 修正内容

1. エラーメッセージの詳細化
2. APIエンドポイントのエラーログ改善

## 次のステップ

サーバーを再起動して、ブラウザのコンソールで詳細なエラーメッセージを確認してください。

