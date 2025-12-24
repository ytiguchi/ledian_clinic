#!/bin/bash
# D1マイグレーション実行スクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 引数チェック
if [ "$1" = "" ]; then
  echo "Usage: $0 [internal|public] [stg|prod]"
  echo "  internal prod - internal production database"
  echo "  public stg    - public preview database"
  echo "  public prod   - public production database"
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

if [ "$ENV" = "stg" ]; then
  if [ "$SITE_TYPE" = "internal" ]; then
    echo "Error: internal preview database is not available"
    exit 1
  fi
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


