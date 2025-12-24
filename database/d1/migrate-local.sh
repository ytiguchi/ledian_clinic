#!/bin/bash
# ローカルD1マイグレーション実行スクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 引数チェック
if [ "$1" = "" ]; then
  echo "Usage: $0 [internal|public]"
  echo "  internal - internal local database"
  echo "  public   - public local database"
  exit 1
fi

SITE_TYPE=$1

if [ "$SITE_TYPE" = "internal" ]; then
  CONFIG_FILE="wrangler.internal.toml"
  DB_NAME="ledian-internal-prod"
elif [ "$SITE_TYPE" = "public" ]; then
  CONFIG_FILE="wrangler.toml"
  DB_NAME="ledian-public-prod"
else
  echo "Error: SITE_TYPE must be 'internal' or 'public'"
  exit 1
fi

cd "$PROJECT_ROOT"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE not found"
  exit 1
fi

# Node.jsバージョンチェック
NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  echo "Error: Node.js v20.0.0 or higher is required (current: $(node --version))"
  exit 1
fi

echo "Applying migrations to ${SITE_TYPE} local database..."
echo "Y" | npx wrangler@4.56.0 d1 migrations apply "$DB_NAME" --config "$CONFIG_FILE" --local

echo "Migration completed successfully!"



