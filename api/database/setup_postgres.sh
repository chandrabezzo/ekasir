#!/bin/bash

# ============================================
# PostgreSQL Database Setup Script
# ============================================

echo "╔════════════════════════════════════════════════════════╗"
echo "║     e-Kasir PostgreSQL Database Setup                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Configuration
DB_NAME="${DB_NAME:-ekasir}"
DB_USER="${DB_USER:-ekasir_user}"
DB_PASSWORD="${DB_PASSWORD:-ekasir_password}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Configuration:"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Host: $DB_HOST:$DB_PORT"
echo ""

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo -e "${RED}✗ PostgreSQL is not installed${NC}"
    echo "Please install PostgreSQL first:"
    echo "  macOS: brew install postgresql"
    echo "  Ubuntu: sudo apt-get install postgresql"
    echo "  Docs: https://www.postgresql.org/download/"
    exit 1
fi

echo -e "${GREEN}✓ PostgreSQL is installed${NC}"

# Check if PostgreSQL is running
if ! pg_isready -h $DB_HOST -p $DB_PORT &> /dev/null; then
    echo -e "${YELLOW}⚠ PostgreSQL is not running${NC}"
    echo "Starting PostgreSQL..."
    
    # Try to start PostgreSQL (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew services start postgresql@14 || brew services start postgresql
    # Linux
    else
        sudo systemctl start postgresql
    fi
    
    sleep 2
    
    if ! pg_isready -h $DB_HOST -p $DB_PORT &> /dev/null; then
        echo -e "${RED}✗ Failed to start PostgreSQL${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ PostgreSQL is running${NC}"

# Create database and user
echo ""
echo "Creating database and user..."

# Connect as postgres superuser
PGPASSWORD="${POSTGRES_PASSWORD:-}" psql -h $DB_HOST -p $DB_PORT -U postgres -c "SELECT 1" &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Note: Using current user instead of postgres${NC}"
    PSQL_ADMIN_USER=$USER
else
    PSQL_ADMIN_USER=postgres
fi

# Create user if not exists
PGPASSWORD="${POSTGRES_PASSWORD:-}" psql -h $DB_HOST -p $DB_PORT -U $PSQL_ADMIN_USER <<EOF
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = '$DB_USER') THEN
        CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
        RAISE NOTICE 'User $DB_USER created';
    ELSE
        RAISE NOTICE 'User $DB_USER already exists';
    END IF;
END
\$\$;
EOF

# Create database if not exists
PGPASSWORD="${POSTGRES_PASSWORD:-}" psql -h $DB_HOST -p $DB_PORT -U $PSQL_ADMIN_USER <<EOF
SELECT 'CREATE DATABASE $DB_NAME OWNER $DB_USER'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec
\c $DB_NAME
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
GRANT ALL PRIVILEGES ON SCHEMA public TO $DB_USER;
EOF

echo -e "${GREEN}✓ Database and user ready${NC}"

# Run schema
echo ""
echo "Creating schema..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f schema.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Schema created successfully${NC}"
else
    echo -e "${RED}✗ Failed to create schema${NC}"
    exit 1
fi

# Ask to seed data
echo ""
read -p "Do you want to seed sample data? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Seeding data..."
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f seed.sql
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Data seeded successfully${NC}"
    else
        echo -e "${RED}✗ Failed to seed data${NC}"
        exit 1
    fi
fi

# Create .env database config
echo ""
echo "Creating database configuration..."

cat > ../.env.database <<EOF
# PostgreSQL Database Configuration
DB_TYPE=postgresql
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_SSL=false
EOF

echo -e "${GREEN}✓ Configuration saved to .env.database${NC}"

# Success message
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║               Setup Complete! 🎉                       ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Database URL:"
echo "  postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"
echo ""
echo "Test connection:"
echo "  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME"
echo ""
echo "Next steps:"
echo "  1. Update your .env file with database credentials"
echo "  2. Install postgres package: dart pub add postgres"
echo "  3. Update repositories to use database"
echo ""
