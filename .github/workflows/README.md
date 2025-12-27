# GitHub Actions ワークフロー

## デプロイ保護ポリシー

| サイト | 本番デプロイ | プレビューデプロイ |
|--------|------------|------------------|
| Internal Site | 手動確認必須 | - |
| Public Site | 手動確認必須 | develop/feature自動 |

---

## Public Site デプロイ

### ブランチ構成

```
main ─────────────→ 本番 (ledianclinic.jp)
  │                   ↑ 手動デプロイのみ
  │                   │
develop ──────────→ ステージング (develop.ledian-clinic-public.pages.dev)
  │                   ↑ 自動デプロイ
  │                   │
feature/xxx ──────→ プレビュー (<branch>.ledian-clinic-public.pages.dev)
                      ↑ 自動デプロイ
```

### 開発フロー

1. `develop` ブランチから `feature/xxx` ブランチを作成
2. 開発・プッシュ → 自動でプレビューURLが発行
3. 確認OK → `develop` にマージ → ステージングで確認
4. 問題なし → `main` にマージ → **手動で本番デプロイを実行**

### 本番デプロイの実行方法

1. GitHubリポジトリの「Actions」タブに移動
2. 左サイドバーから「Deploy Public Site」を選択
3. 「Run workflow」ボタンをクリック
4. **Branch**: `main` を選択
5. **confirm**: `deploy` と入力
6. **environment**: `production` を選択
7. 「Run workflow」ボタンをクリックして実行

### プレビューデプロイ（自動）

以下の条件で自動的にプレビューがデプロイされます：

- `develop` ブランチへのプッシュ
- `feature/**` ブランチへのプッシュ
- `apps/public-site/**` 配下のファイル変更時

---

## Internal Site デプロイ

### 手動デプロイの実行方法

1. GitHubリポジトリの「Actions」タブに移動
2. 左サイドバーから「Deploy Internal Site to Production」を選択
3. 「Run workflow」ボタンをクリック
4. 確認入力欄に `deploy` と入力
5. 「Run workflow」ボタンをクリックして実行

---

## 必要なシークレット設定

GitHubリポジトリの Settings → Secrets and variables → Actions で以下を設定してください：

| シークレット名 | 説明 |
|--------------|------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare APIトークン（Pages/D1権限が必要） |
| `CLOUDFLARE_ACCOUNT_ID` | CloudflareアカウントID |

### APIトークンの取得方法

1. Cloudflare Dashboard → My Profile → API Tokens
2. 「Create Token」をクリック
3. 「Edit Cloudflare Workers」テンプレートを選択
4. 権限を設定：
   - Account: Cloudflare Pages: Edit
   - Account: Workers Scripts: Edit
   - Account: D1: Edit
   - Account: R2: Edit（画像アップロード用）
5. トークンを生成してGitHubシークレットに設定

---

## 注意事項

- 本番デプロイは手動確認が必須です（誤デプロイ防止）
- デプロイ前に必ずローカルで動作確認を行ってください
- `main` ブランチへの直接プッシュは避け、PRを使用してください
