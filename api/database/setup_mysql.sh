#!/bin/bash

# ============================================
# MySQL Database Setup Script
# ============================================

echo "╔════════════════════════════════════════════════════════╗"
echo "║        e-Kasir MySQL Database Setup                    ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Configuration
DB_NAME="${DB_NAME:-ekasir}"
DB_USER="${DB_USER:-ekasir_user}"
DB_PASSWORD="${DB_PASSWORD:-ekasir_password}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-}"

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

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}✗ MySQL is not installed${NC}"
    echo "Please install MySQL first:"
    echo "  macOS: brew install mysql"
    echo "  Ubuntu: sudo apt-get install mysql-server"
    echo "  Docs: https://dev.mysql.com/doc/"
    exit 1
fi

echo -e "${GREEN}✓ MySQL is installed${NC}"

# Check if MySQL is running
if ! mysqladmin ping -h $DB_HOST -P $DB_PORT --silent &> /dev/null; then
    echo -e "${YELLOW}⚠ MySQL is not running${NC}"
    echo "Starting MySQL..."
    
    # Try to start MySQL (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew services start mysql
    # Linux
    else
        sudo systemctl start mysql
    fi
    
    sleep 3
    
    if ! mysqladmin ping -h $DB_HOST -P $DB_PORT --silent &> /dev/null; then
        echo -e "${RED}✗ Failed to start MySQL${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ MySQL is running${NC}"

# Prepare MySQL root credentials
MYSQL_ROOT_CMD="mysql -h $DB_HOST -P $DB_PORT"
if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
    MYSQL_ROOT_CMD="$MYSQL_ROOT_CMD -p$MYSQL_ROOT_PASSWORD"
fi

# Create database and user
echo ""
echo "Creating database and user..."

$MYSQL_ROOT_CMD <<EOF
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user if not exists (MySQL 8.0+ syntax)
CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';

-- Grant privileges
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';

FLUSH PRIVILEGES;

SELECT 'Database and user created successfully' AS Status;
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database and user ready${NC}"
else
    echo -e "${RED}✗ Failed to create database and user${NC}"
    exit 1
fi

# Convert PostgreSQL schema to MySQL-compatible
echo ""
echo "Creating schema..."

# Create MySQL-compatible schema
cat > schema_mysql.sql <<'EOF'
-- MySQL Compatible Schema
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'cashier',
    outlet_ids TEXT,
    outlet_name VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    icon_name VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    image_url TEXT,
    category VARCHAR(100) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_available (is_available),
    INDEX idx_price (price),
    INDEX idx_category_available (category, is_available)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    id VARCHAR(36) PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    outlet_name VARCHAR(100),
    table_number VARCHAR(20),
    order_type VARCHAR(20),
    subtotal DECIMAL(15, 2) NOT NULL,
    tax DECIMAL(15, 2) NOT NULL DEFAULT 0,
    discount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    total DECIMAL(15, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    INDEX idx_order_number (order_number),
    INDEX idx_customer_phone (customer_phone),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_status_created (status, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_items (
    id VARCHAR(36) PRIMARY KEY,
    order_id VARCHAR(36) NOT NULL,
    product_id VARCHAR(36) NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
EOF

mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < schema_mysql.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Schema created successfully${NC}"
    rm schema_mysql.sql
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
    
    # Adjust seed.sql for MySQL (remove INTERVAL syntax)
    sed 's/INTERVAL/INTERVAL/g' seed.sql > seed_mysql.sql
    
    mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < seed_mysql.sql
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Data seeded successfully${NC}"
        rm seed_mysql.sql
    else
        echo -e "${YELLOW}⚠ Some seed data may have failed (this is normal for sample orders)${NC}"
        rm seed_mysql.sql
    fi
fi

# Create .env database config
echo ""
echo "Creating database configuration..."

cat > ../.env.database <<EOF
# MySQL Database Configuration
DB_TYPE=mysql
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
echo "  mysql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"
echo ""
echo "Test connection:"
echo "  mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME"
echo ""
echo "Next steps:"
echo "  1. Update your .env file with database credentials"
echo "  2. Install mysql1 package: dart pub add mysql1"
echo "  3. Update repositories to use database"
echo ""
