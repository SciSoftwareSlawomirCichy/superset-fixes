#!/bin/bash
# Apache Superset Initialization Script
# This script initializes a new Superset instance

set -e

echo "Starting Apache Superset initialization..."

# Check if required environment variables are set
if [ -z "$DATABASE_URL" ]; then
    echo "Warning: DATABASE_URL not set, using default SQLite database"
    export DATABASE_URL="sqlite:////app/superset.db"
fi

if [ -z "$SECRET_KEY" ]; then
    echo "Error: SECRET_KEY must be set"
    echo "Generate one using: openssl rand -base64 42"
    exit 1
fi

# Step 1: Upgrade database to the latest version
echo "Step 1: Upgrading database schema..."
superset db upgrade

# Step 2: Create admin user
echo "Step 2: Creating admin user..."
if [ -z "$ADMIN_USERNAME" ]; then
    export ADMIN_USERNAME="admin"
fi
if [ -z "$ADMIN_PASSWORD" ]; then
    export ADMIN_PASSWORD="admin"
fi
if [ -z "$ADMIN_EMAIL" ]; then
    export ADMIN_EMAIL="admin@superset.com"
fi
if [ -z "$ADMIN_FIRSTNAME" ]; then
    export ADMIN_FIRSTNAME="Superset"
fi
if [ -z "$ADMIN_LASTNAME" ]; then
    export ADMIN_LASTNAME="Admin"
fi

superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "$ADMIN_FIRSTNAME" \
    --lastname "$ADMIN_LASTNAME" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD" || echo "Admin user may already exist"

# Step 3: Initialize Superset (create default roles and permissions)
echo "Step 3: Initializing Superset..."
superset init

# Step 4: Load examples (optional)
if [ "$SUPERSET_LOAD_EXAMPLES" = "yes" ]; then
    echo "Step 4: Loading example data..."
    superset load_examples
else
    echo "Step 4: Skipping example data (set SUPERSET_LOAD_EXAMPLES=yes to enable)"
fi

echo "Superset initialization complete!"
echo ""
echo "You can now access Superset at http://localhost:8088"
echo "Default credentials:"
echo "  Username: $ADMIN_USERNAME"
echo "  Password: $ADMIN_PASSWORD"
echo ""
echo "To start Superset, run:"
echo "  docker-compose up -d"
echo ""
