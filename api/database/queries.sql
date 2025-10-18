-- ============================================
-- Common Queries for e-Kasir Database
-- ============================================

-- ============================================
-- USER QUERIES
-- ============================================

-- Get all users
SELECT id, username, name, role, outlet_name, created_at
FROM users
ORDER BY created_at DESC;

-- Get user by username
SELECT * FROM users WHERE username = 'admin';

-- Get users by role
SELECT * FROM users WHERE role = 'cashier';

-- Count users by role
SELECT role, COUNT(*) as count
FROM users
GROUP BY role;

-- ============================================
-- CATEGORY QUERIES
-- ============================================

-- Get all active categories
SELECT * FROM categories
WHERE is_active = TRUE
ORDER BY name;

-- Get categories with product count
SELECT 
    c.id,
    c.name,
    c.description,
    c.is_active,
    COUNT(p.id) as product_count
FROM categories c
LEFT JOIN products p ON c.name = p.category
GROUP BY c.id, c.name, c.description, c.is_active
ORDER BY product_count DESC;

-- Get category by name
SELECT * FROM categories WHERE name = 'Food';

-- ============================================
-- PRODUCT QUERIES
-- ============================================

-- Get all available products
SELECT * FROM products
WHERE is_available = TRUE
ORDER BY category, name;

-- Get products by category
SELECT * FROM products
WHERE category = 'Food' AND is_available = TRUE
ORDER BY name;

-- Get products with price range
SELECT * FROM products
WHERE price BETWEEN 10000 AND 30000
AND is_available = TRUE
ORDER BY price;

-- Search products by name
SELECT * FROM products
WHERE name LIKE '%Goreng%'
ORDER BY name;

-- Get most expensive products
SELECT * FROM products
ORDER BY price DESC
LIMIT 10;

-- Get cheapest products
SELECT * FROM products
ORDER BY price ASC
LIMIT 10;

-- ============================================
-- ORDER QUERIES
-- ============================================

-- Get all orders
SELECT * FROM orders
ORDER BY created_at DESC;

-- Get orders by status
SELECT * FROM orders
WHERE status = 'pending'
ORDER BY created_at DESC;

-- Get today's orders
SELECT * FROM orders
WHERE DATE(created_at) = CURRENT_DATE
ORDER BY created_at DESC;

-- Get orders this week
SELECT * FROM orders
WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE)
ORDER BY created_at DESC;

-- Get orders this month
SELECT * FROM orders
WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE)
ORDER BY created_at DESC;

-- Get orders by customer phone
SELECT * FROM orders
WHERE customer_phone = '081234567890'
ORDER BY created_at DESC;

-- Get orders with customer details
SELECT 
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.total,
    o.status,
    o.created_at,
    COUNT(oi.id) as item_count
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.order_number, o.customer_name, o.customer_phone, o.total, o.status, o.created_at
ORDER BY o.created_at DESC;

-- Get order with items
SELECT 
    o.*,
    json_agg(
        json_build_object(
            'id', oi.id,
            'product_name', oi.product_name,
            'quantity', oi.quantity,
            'price', oi.price,
            'notes', oi.notes
        )
    ) as items
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.order_number = 'ORD-000001'
GROUP BY o.id;

-- ============================================
-- ORDER STATISTICS
-- ============================================

-- Overall statistics
SELECT * FROM order_statistics;

-- Daily revenue
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_orders,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as revenue
FROM orders
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC
LIMIT 30;

-- Monthly revenue
SELECT 
    TO_CHAR(created_at, 'YYYY-MM') as month,
    COUNT(*) as total_orders,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as revenue
FROM orders
GROUP BY TO_CHAR(created_at, 'YYYY-MM')
ORDER BY month DESC;

-- Revenue by order type
SELECT 
    order_type,
    COUNT(*) as total_orders,
    SUM(total) as total_revenue,
    AVG(total) as average_order_value
FROM orders
WHERE status = 'completed'
GROUP BY order_type
ORDER BY total_revenue DESC;

-- Top customers by spending
SELECT 
    customer_name,
    customer_phone,
    COUNT(*) as total_orders,
    SUM(total) as total_spent,
    AVG(total) as average_order_value
FROM orders
WHERE status = 'completed'
GROUP BY customer_name, customer_phone
ORDER BY total_spent DESC
LIMIT 10;

-- ============================================
-- PRODUCT PERFORMANCE
-- ============================================

-- Best selling products
SELECT 
    p.name,
    p.category,
    p.price,
    COALESCE(SUM(oi.quantity), 0) as total_sold,
    COALESCE(SUM(oi.quantity * oi.price), 0) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'completed'
GROUP BY p.id, p.name, p.category, p.price
ORDER BY total_sold DESC
LIMIT 10;

-- Revenue by category
SELECT 
    p.category,
    COUNT(DISTINCT p.id) as product_count,
    COALESCE(SUM(oi.quantity), 0) as total_items_sold,
    COALESCE(SUM(oi.quantity * oi.price), 0) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'completed'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Products never ordered
SELECT * FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.id
)
ORDER BY p.name;

-- Low stock alert (if you add stock field)
-- SELECT * FROM products WHERE stock < 10 AND is_available = TRUE;

-- ============================================
-- PEAK HOURS ANALYSIS
-- ============================================

-- Orders by hour of day
SELECT 
    EXTRACT(HOUR FROM created_at) as hour,
    COUNT(*) as order_count,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as revenue
FROM orders
GROUP BY EXTRACT(HOUR FROM created_at)
ORDER BY hour;

-- Orders by day of week
SELECT 
    TO_CHAR(created_at, 'Day') as day_of_week,
    COUNT(*) as order_count,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as revenue
FROM orders
GROUP BY TO_CHAR(created_at, 'Day'), EXTRACT(DOW FROM created_at)
ORDER BY EXTRACT(DOW FROM created_at);

-- ============================================
-- ADMIN MAINTENANCE QUERIES
-- ============================================

-- Clean up old cancelled orders (older than 30 days)
DELETE FROM orders
WHERE status = 'cancelled'
AND created_at < CURRENT_DATE - INTERVAL '30 days';

-- Update product availability
UPDATE products
SET is_available = FALSE
WHERE id = 'prod-001';

-- Update order status
UPDATE orders
SET status = 'completed',
    completed_at = CURRENT_TIMESTAMP
WHERE id = 'order-001';

-- Bulk update prices (increase by 10%)
UPDATE products
SET price = price * 1.10
WHERE category = 'Food';

-- Archive old completed orders (move to archive table)
-- CREATE TABLE orders_archive AS SELECT * FROM orders WHERE status = 'completed' AND completed_at < CURRENT_DATE - INTERVAL '90 days';
-- DELETE FROM orders WHERE id IN (SELECT id FROM orders_archive);

-- ============================================
-- DATABASE HEALTH CHECKS
-- ============================================

-- Table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- Record counts
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;

-- ============================================
-- BACKUP & RESTORE
-- ============================================

-- Backup command (run in terminal):
-- pg_dump -U ekasir_user -h localhost ekasir > backup_$(date +%Y%m%d).sql

-- Restore command (run in terminal):
-- psql -U ekasir_user -h localhost ekasir < backup_20241018.sql

-- MySQL Backup:
-- mysqldump -u ekasir_user -p ekasir > backup_$(date +%Y%m%d).sql

-- MySQL Restore:
-- mysql -u ekasir_user -p ekasir < backup_20241018.sql
