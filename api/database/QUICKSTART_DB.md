# Database Quick Start Guide

## 🚀 One-Command Setup

### PostgreSQL
```bash
cd api/database
./setup_postgres.sh
```

### MySQL
```bash
cd api/database
./setup_mysql.sh
```

That's it! The script will:
- ✅ Check if database is installed and running
- ✅ Create database and user
- ✅ Set up all tables, indexes, views, and triggers
- ✅ Optionally seed sample data
- ✅ Generate configuration file

## 📋 Prerequisites

### Install PostgreSQL

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**Windows:**
Download from https://www.postgresql.org/download/windows/

### Install MySQL

**macOS:**
```bash
brew install mysql
brew services start mysql
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation
```

**Windows:**
Download from https://dev.mysql.com/downloads/mysql/

## 🎯 What You Get

After running the setup script:

### Database Tables (5)
- ✅ **users** - User accounts with roles
- ✅ **categories** - Product categories
- ✅ **products** - Menu items
- ✅ **orders** - Customer orders
- ✅ **order_items** - Order details

### Views (4)
- ✅ **active_products** - Available products with categories
- ✅ **order_statistics** - Real-time stats
- ✅ **daily_sales** - Sales by date
- ✅ **popular_products** - Best sellers

### Sample Data (Optional)
- 3 users (admin, cashier, manager)
- 5 categories
- 20 products
- 4 sample orders

### Configuration
- `.env.database` file with connection details

## 🔌 Test Your Connection

### PostgreSQL
```bash
psql -U ekasir_user -h localhost -d ekasir

# Run a test query
SELECT * FROM users;
```

### MySQL
```bash
mysql -u ekasir_user -p -h localhost ekasir

# Run a test query
SELECT * FROM users;
```

## 📊 Quick Queries

### View Statistics
```sql
SELECT * FROM order_statistics;
```

### Get Today's Orders
```sql
SELECT * FROM orders 
WHERE DATE(created_at) = CURRENT_DATE;
```

### Best Selling Products
```sql
SELECT * FROM popular_products LIMIT 10;
```

### Daily Revenue
```sql
SELECT * FROM daily_sales LIMIT 7;
```

## 🔧 Common Issues

### "psql: command not found"
PostgreSQL is not in PATH. 
```bash
# macOS
export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
```

### "mysql: command not found"
MySQL is not in PATH.
```bash
# macOS
export PATH="/usr/local/mysql/bin:$PATH"
```

### "Connection refused"
Database service is not running.
```bash
# PostgreSQL
brew services start postgresql@14  # macOS
sudo systemctl start postgresql    # Linux

# MySQL
brew services start mysql           # macOS
sudo systemctl start mysql          # Linux
```

### "Authentication failed"
Check your root password or use setup script with environment variables:
```bash
# PostgreSQL
POSTGRES_PASSWORD=your_root_password ./setup_postgres.sh

# MySQL
MYSQL_ROOT_PASSWORD=your_root_password ./setup_mysql.sh
```

## 🎨 Customize Setup

Set environment variables before running:

```bash
# Custom database name
export DB_NAME=my_custom_db

# Custom user credentials
export DB_USER=my_user
export DB_PASSWORD=my_secure_password

# Custom host/port
export DB_HOST=192.168.1.100
export DB_PORT=5433

# Run setup
./setup_postgres.sh
```

## 📚 Next Steps

1. **Update Backend Code**
   ```bash
   # Add database package
   cd ..
   dart pub add postgres  # or mysql1
   ```

2. **Configure Environment**
   ```bash
   # Copy database config to main .env
   cat .env.database >> .env
   ```

3. **Update Repositories**
   - Replace in-memory storage with database queries
   - See `DATABASE.md` for implementation guide

4. **Test API**
   ```bash
   dart run bin/server.dart
   ```

## 🔐 Default Credentials

After seeding data:

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | admin |
| cashier | cashier123 | cashier |
| manager | manager123 | manager |

⚠️ **Change these in production!**

## 📖 Full Documentation

- `schema.sql` - Database structure
- `seed.sql` - Sample data
- `queries.sql` - Common queries
- `DATABASE.md` - Complete documentation

## 💡 Pro Tips

1. **Backup before testing:**
   ```bash
   pg_dump ekasir > backup_before_test.sql
   ```

2. **Reset database:**
   ```bash
   ./setup_postgres.sh  # Will ask before overwriting
   ```

3. **View schema visually:**
   - Use tools like DBeaver, pgAdmin, or MySQL Workbench

4. **Monitor performance:**
   ```sql
   -- PostgreSQL
   SELECT * FROM pg_stat_statements;
   
   -- MySQL
   SHOW PROCESSLIST;
   ```

## 🆘 Need Help?

- Check `DATABASE.md` for detailed documentation
- Review `queries.sql` for query examples
- Check database logs:
  ```bash
  # PostgreSQL logs
  tail -f /usr/local/var/log/postgresql@14.log
  
  # MySQL logs
  tail -f /usr/local/mysql/data/*.err
  ```

Happy coding! 🎉
