# e-Kasir Database Documentation

## Overview

This directory contains all database-related files for the e-Kasir POS system, including schema definitions, seed data, setup scripts, and common queries.

## Files

```
database/
├── schema.sql              # Database schema (tables, indexes, views, triggers)
├── seed.sql                # Sample data for testing
├── queries.sql             # Common SQL queries
├── setup_postgres.sh       # Automated PostgreSQL setup
├── setup_mysql.sh          # Automated MySQL setup
└── DATABASE.md             # This file
```

## Quick Start

### PostgreSQL Setup

```bash
cd api/database
chmod +x setup_postgres.sh
./setup_postgres.sh
```

### MySQL Setup

```bash
cd api/database
chmod +x setup_mysql.sh
./setup_mysql.sh
```

## Database Schema

### Tables

#### 1. **users**
User accounts for authentication and authorization.

| Column | Type | Description |
|--------|------|-------------|
| id | VARCHAR(36) | Primary key (UUID) |
| username | VARCHAR(50) | Unique username |
| password | VARCHAR(255) | BCrypt hashed password |
| name | VARCHAR(100) | Full name |
| role | VARCHAR(20) | User role (admin, cashier, manager) |
| outlet_ids | TEXT | JSON array of accessible outlets |
| outlet_name | VARCHAR(100) | Primary outlet name |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

**Indexes:** username, role

#### 2. **categories**
Product categories for organizing menu items.

| Column | Type | Description |
|--------|------|-------------|
| id | VARCHAR(36) | Primary key (UUID) |
| name | VARCHAR(100) | Unique category name |
| description | TEXT | Category description |
| icon_name | VARCHAR(50) | Icon identifier |
| is_active | BOOLEAN | Active status |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

**Indexes:** name, is_active

#### 3. **products**
Menu items/products available for sale.

| Column | Type | Description |
|--------|------|-------------|
| id | VARCHAR(36) | Primary key (UUID) |
| name | VARCHAR(200) | Product name |
| description | TEXT | Product description |
| price | DECIMAL(15,2) | Product price |
| image_url | TEXT | Image URL |
| category | VARCHAR(100) | Category name |
| is_available | BOOLEAN | Availability status |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

**Indexes:** name, category, is_available, price, (category, is_available)

#### 4. **orders**
Customer orders with payment information.

| Column | Type | Description |
|--------|------|-------------|
| id | VARCHAR(36) | Primary key (UUID) |
| order_number | VARCHAR(20) | Unique order number |
| customer_name | VARCHAR(100) | Customer name |
| customer_phone | VARCHAR(20) | Customer phone |
| outlet_name | VARCHAR(100) | Outlet name |
| table_number | VARCHAR(20) | Table number (if dine-in) |
| order_type | VARCHAR(20) | Dine-in, Takeaway, Delivery |
| subtotal | DECIMAL(15,2) | Subtotal amount |
| tax | DECIMAL(15,2) | Tax amount |
| discount | DECIMAL(15,2) | Discount amount |
| total | DECIMAL(15,2) | Total amount |
| status | VARCHAR(20) | pending, processing, completed, cancelled |
| notes | TEXT | Order notes |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |
| completed_at | TIMESTAMP | Completion timestamp |

**Indexes:** order_number, customer_phone, status, created_at, (status, created_at)

#### 5. **order_items**
Individual items within each order.

| Column | Type | Description |
|--------|------|-------------|
| id | VARCHAR(36) | Primary key (UUID) |
| order_id | VARCHAR(36) | Foreign key to orders |
| product_id | VARCHAR(36) | Product reference |
| product_name | VARCHAR(200) | Product name snapshot |
| quantity | INT | Quantity ordered |
| price | DECIMAL(15,2) | Price at time of order |
| notes | TEXT | Item-specific notes |
| created_at | TIMESTAMP | Creation timestamp |

**Indexes:** order_id, product_id  
**Foreign Key:** order_id → orders(id) ON DELETE CASCADE

### Views

#### 1. **active_products**
Shows all available products with category information.

```sql
SELECT * FROM active_products WHERE category = 'Food';
```

#### 2. **order_statistics**
Aggregated order statistics and revenue.

```sql
SELECT * FROM order_statistics;
-- Returns: total_orders, pending_orders, completed_orders, total_revenue, etc.
```

#### 3. **daily_sales**
Daily sales breakdown by date.

```sql
SELECT * FROM daily_sales WHERE date >= CURRENT_DATE - INTERVAL '7 days';
```

#### 4. **popular_products**
Products ranked by sales performance.

```sql
SELECT * FROM popular_products LIMIT 10;
```

### Triggers

**Auto-update timestamps:** All tables with `updated_at` columns automatically update the timestamp on record modification.

## Manual Setup

### PostgreSQL

```bash
# 1. Create database
createdb ekasir

# 2. Create user
psql -c "CREATE USER ekasir_user WITH PASSWORD 'your_password';"

# 3. Grant privileges
psql -c "GRANT ALL PRIVILEGES ON DATABASE ekasir TO ekasir_user;"

# 4. Run schema
psql -U ekasir_user -d ekasir -f schema.sql

# 5. Seed data (optional)
psql -U ekasir_user -d ekasir -f seed.sql
```

### MySQL

```bash
# 1. Login to MySQL
mysql -u root -p

# 2. Create database and user
CREATE DATABASE ekasir CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'ekasir_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON ekasir.* TO 'ekasir_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 3. Run schema
mysql -u ekasir_user -p ekasir < schema.sql

# 4. Seed data (optional)
mysql -u ekasir_user -p ekasir < seed.sql
```

## Sample Data

The `seed.sql` file includes:
- **3 users:** admin, cashier, manager
- **5 categories:** Food, Beverage, Snack, Dessert, Appetizer
- **20 products:** Various menu items across categories
- **4 sample orders:** With different statuses and items

### Default Credentials

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | admin |
| cashier | cashier123 | cashier |
| manager | manager123 | manager |

## Common Queries

See `queries.sql` for a comprehensive collection including:

### User Queries
- Get all users
- Get users by role
- Count users by role

### Product Queries
- Get available products
- Search products
- Filter by category/price
- Best selling products

### Order Queries
- Get orders by status
- Today's/weekly/monthly orders
- Order statistics
- Revenue reports

### Analytics
- Daily/monthly revenue
- Top customers
- Popular products
- Peak hours analysis

## Database Configuration

### Environment Variables

Add to your `.env` file:

```env
# PostgreSQL
DB_TYPE=postgresql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ekasir
DB_USER=ekasir_user
DB_PASSWORD=your_password
DB_SSL=false

# Or MySQL
DB_TYPE=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=ekasir
DB_USER=ekasir_user
DB_PASSWORD=your_password
DB_SSL=false
```

### Connection String

**PostgreSQL:**
```
postgresql://ekasir_user:your_password@localhost:5432/ekasir
```

**MySQL:**
```
mysql://ekasir_user:your_password@localhost:3306/ekasir
```

## Backup & Restore

### PostgreSQL

**Backup:**
```bash
pg_dump -U ekasir_user -h localhost ekasir > backup_$(date +%Y%m%d).sql
```

**Restore:**
```bash
psql -U ekasir_user -h localhost ekasir < backup_20241018.sql
```

**Backup with compression:**
```bash
pg_dump -U ekasir_user -h localhost ekasir | gzip > backup_$(date +%Y%m%d).sql.gz
```

### MySQL

**Backup:**
```bash
mysqldump -u ekasir_user -p ekasir > backup_$(date +%Y%m%d).sql
```

**Restore:**
```bash
mysql -u ekasir_user -p ekasir < backup_20241018.sql
```

**Backup with compression:**
```bash
mysqldump -u ekasir_user -p ekasir | gzip > backup_$(date +%Y%m%d).sql.gz
```

## Migration Strategy

### Adding New Columns

```sql
-- Add column
ALTER TABLE products ADD COLUMN stock INT DEFAULT 0;

-- Add index
CREATE INDEX idx_products_stock ON products(stock);

-- Update existing records
UPDATE products SET stock = 100 WHERE is_available = TRUE;
```

### Adding New Tables

```sql
CREATE TABLE outlets (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key to existing table
ALTER TABLE orders ADD COLUMN outlet_id VARCHAR(36);
ALTER TABLE orders ADD CONSTRAINT fk_outlet FOREIGN KEY (outlet_id) REFERENCES outlets(id);
```

## Performance Optimization

### Indexes

Existing indexes are optimized for common queries. Add custom indexes as needed:

```sql
-- For frequent searches
CREATE INDEX idx_products_name_search ON products(name);

-- For date range queries
CREATE INDEX idx_orders_date_range ON orders(created_at, status);

-- Composite indexes for complex queries
CREATE INDEX idx_orders_customer_status ON orders(customer_phone, status, created_at);
```

### Query Optimization

```sql
-- Use EXPLAIN to analyze queries
EXPLAIN ANALYZE SELECT * FROM orders WHERE status = 'pending';

-- Add covering indexes for specific queries
CREATE INDEX idx_orders_covering ON orders(status, created_at) INCLUDE (total, customer_name);
```

## Monitoring

### Table Sizes (PostgreSQL)

```sql
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Index Usage

```sql
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

## Troubleshooting

### Connection Issues

```bash
# Test PostgreSQL connection
psql -U ekasir_user -h localhost -d ekasir -c "SELECT 1;"

# Test MySQL connection
mysql -u ekasir_user -p -h localhost -e "USE ekasir; SELECT 1;"
```

### Permission Issues

```sql
-- PostgreSQL
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ekasir_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ekasir_user;

-- MySQL
GRANT ALL PRIVILEGES ON ekasir.* TO 'ekasir_user'@'localhost';
FLUSH PRIVILEGES;
```

### Reset Database

```bash
# PostgreSQL
dropdb ekasir && createdb ekasir
psql -U ekasir_user -d ekasir -f schema.sql

# MySQL
mysql -u root -p -e "DROP DATABASE ekasir; CREATE DATABASE ekasir;"
mysql -u ekasir_user -p ekasir < schema.sql
```

## Production Considerations

1. **Security:**
   - Use strong passwords
   - Limit network access
   - Enable SSL/TLS
   - Regular security audits

2. **Backup:**
   - Automated daily backups
   - Off-site backup storage
   - Test restore procedures

3. **Monitoring:**
   - Database performance metrics
   - Query performance tracking
   - Alert system for issues

4. **Scaling:**
   - Connection pooling
   - Read replicas
   - Caching layer
   - Database sharding (if needed)

## Support

For issues or questions:
- Check this documentation
- Review `queries.sql` for examples
- Consult PostgreSQL/MySQL documentation
- Check server logs for errors
