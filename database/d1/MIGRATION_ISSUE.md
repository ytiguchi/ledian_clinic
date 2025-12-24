# D1マイグレーション実行時の問題

## ⚠️ 現在の問題

Node.jsのバージョンが古いため、wranglerが実行できません。

- **要求バージョン**: Node.js v20.0.0以上
- **現在のバージョン**: v19.7.0

## 🔧 解決方法

### 方法1: Node.jsをアップグレード（推奨）

#### nvmを使用している場合
```bash
# Node.js v20をインストール
nvm install 20
nvm use 20

# マイグレーション実行
./database/d1/migrate.sh internal stg
```

#### voltaを使用している場合
```bash
# Node.js v20を設定
volta install node@20

# マイグレーション実行
./database/d1/migrate.sh internal stg
```

#### 直接インストールしている場合
- [Node.js公式サイト](https://nodejs.org/)からv20以上をダウンロード・インストール

### 方法2: 一時的にnpxで実行（Node.js v20環境がある場合）

```bash
# Node.js v20環境で直接実行
npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote --preview
```

### 方法3: CI/CDで実行（推奨）

GitHub Actions等のCI環境で実行する場合、Node.js v20が自動的に使用されます。

---

## 📋 マイグレーション実行コマンド（Node.js v20環境での実行）

### Staging (Preview)

```bash
# internal staging
npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote --preview

# public staging
npx wrangler@4.56.0 d1 migrations apply ledian-public-prod \
  --config wrangler.toml \
  --remote --preview
```

### Production

```bash
# internal production（確認プロンプトあり）
npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote

# public production（確認プロンプトあり）
npx wrangler@4.56.0 d1 migrations apply ledian-public-prod \
  --config wrangler.toml \
  --remote
```

## 🔍 マイグレーション状態確認

```bash
# 適用済みマイグレーション一覧
npx wrangler@4.56.0 d1 migrations list ledian-internal-prod \
  --config wrangler.internal.toml \
  --remote --preview
```

## ⚡ 次のステップ

1. Node.jsをv20以上にアップグレード
2. マイグレーションを実行
3. 実行結果を確認

