# Node.js v20 アップグレードガイド

## 現在の状況

- **現在のバージョン**: Node.js v19.7.0
- **必要なバージョン**: Node.js v20.0.0以上（wranglerの要件）

## アップグレード方法

### 方法1: nvmを使用（推奨）

#### nvmがインストールされていない場合

```bash
# nvmをインストール
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# シェルを再読み込み
source ~/.zshrc

# Node.js v20をインストール
nvm install 20

# v20を使用
nvm use 20

# デフォルトとして設定（オプション）
nvm alias default 20
```

#### nvmがインストール済みの場合

```bash
# シェル設定を読み込み（まだの場合は）
source ~/.nvm/nvm.sh

# Node.js v20をインストール
nvm install 20

# v20を使用
nvm use 20
```

### 方法2: Homebrewを使用（macOS）

```bash
# HomebrewでNode.jsをアップグレード
brew upgrade node

# または、特定バージョンをインストール
brew install node@20

# パスを設定
echo 'export PATH="/opt/homebrew/opt/node@20/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 方法3: 公式インストーラーを使用

1. [Node.js公式サイト](https://nodejs.org/)にアクセス
2. LTS（v20.x）をダウンロード
3. インストーラーを実行

## アップグレード後の確認

```bash
# バージョン確認
node --version  # v20.x.x と表示されることを確認
npm --version   # npmのバージョンも確認

# マイグレーション実行
cd /Users/iguchiyuuta/Dev/ledian_clinic
./database/d1/migrate.sh internal stg
```

## トラブルシューティング

### nvmコマンドが見つからない

```bash
# ~/.zshrcに以下を追加
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# シェルを再読み込み
source ~/.zshrc
```

### 複数のNode.jsバージョンが混在している場合

```bash
# 使用中のNode.jsのパスを確認
which node

# nvmで管理している場合、nvm use で切り替え
nvm use 20

# デフォルトを設定
nvm alias default 20
```

