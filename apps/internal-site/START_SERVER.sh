#!/bin/bash
# ローカル開発サーバー起動スクリプト

set -e

cd "$(dirname "$0")"

echo "🚀 Starting local development server..."

# Node.js v20を使用
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 2>/dev/null || true

if command -v nvm &> /dev/null || [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm use 20 2>/dev/null || echo "Warning: Could not switch to Node.js v20"
else
  echo "Warning: nvm not found, using system Node.js"
fi

# Node.jsバージョン確認
echo "📌 Node.js version: $(node --version)"

# ビルド
echo "📦 Building..."
npm run build

# wrangler pages dev で起動
echo "🌐 Starting wrangler pages dev on port 8788..."
echo ""
echo "✅ Server will be available at: http://localhost:8788"
echo "✅ API endpoints:"
echo "   - http://localhost:8788/api/categories"
echo "   - http://localhost:8788/api/pricing"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

wrangler pages dev dist --local --port 8788



