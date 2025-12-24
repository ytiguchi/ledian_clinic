#!/bin/bash
# D1マイグレーション実行スクリプト（npx直接実行版）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 引数チェック
if [ "$1" = "" ]; then
  echo "Usage: $0 [internal|public] [stg|prod]"
  exit 1
fi

SITE_TYPE=$1
ENV=${2:-stg}

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
  echo ""
  echo "Please upgrade Node.js or use the manual command:"
  echo "  npx wrangler@4.56.0 d1 migrations apply $DB_NAME --config $CONFIG_FILE --remote ${ENV:+-preview}"
  exit 1
fi

if [ "$ENV" = "stg" ]; then
  echo "Applying migrations to ${SITE_TYPE} staging (preview) database..."
  npx wrangler@4.56.0 d1 migrations apply "$DB_NAME" --config "$CONFIG_FILE" --remote --preview
elif [ "$ENV" = "prod" ]; then
  echo "Applying migrations to ${SITE_TYPE} production database..."
  read -p "Are you sure you want to apply migrations to PRODUCTION? (yes/no): " confirm
  if [ "$confirm" != "yes" ]; then
    echo "Cancelled"
    exit 0
  fi
  npx wrangler@4.56.0 d1 migrations apply "$DB_NAME" --config "$CONFIG_FILE" --remote
else
  echo "Error: ENV must be 'stg' or 'prod'"
  exit 1
fi

echo "Migration completed successfully!"

