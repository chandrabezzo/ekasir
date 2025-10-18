-- ============================================
-- e-Kasir Database Schema (PostgreSQL/MySQL Compatible)
-- ============================================

-- Drop existing tables (in correct order due to foreign keys)
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- Users Table
-- ============================================
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- BCrypt hashed
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'cashier', -- admin, cashier, etc.
    outlet_ids TEXT, -- JSON array of outlet IDs
    outlet_name VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_role (role)
);

-- ============================================
-- Categories Table
-- ============================================
CREATE TABLE categories (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    icon_name VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
);

-- ============================================
-- Products Table
-- ============================================
CREATE TABLE products (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    image_url TEXT,
    category VARCHAR(100) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_available (is_available),
    INDEX idx_price (price)
);

-- ============================================
-- Orders Table
-- ============================================
CREATE TABLE orders (
    id VARCHAR(36) PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    outlet_name VARCHAR(100),
    table_number VARCHAR(20),
    order_type VARCHAR(20), -- Dine-in, Takeaway, Delivery
    subtotal DECIMAL(15, 2) NOT NULL,
    tax DECIMAL(15, 2) NOT NULL DEFAULT 0,
    discount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    total DECIMAL(15, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, cancelled
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    
    INDEX idx_order_number (order_number),
    INDEX idx_customer_phone (customer_phone),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_completed_at (completed_at)
);

-- ============================================
-- Order Items Table
-- ============================================
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
);

-- ============================================
-- Views for Common Queries
-- ============================================

-- Active Products View
CREATE OR REPLACE VIEW active_products AS
SELECT 
    p.*,
    c.name as category_name,
    c.icon_name as category_icon
FROM products p
LEFT JOIN categories c ON p.category = c.name
WHERE p.is_available = TRUE;

-- Order Statistics View
CREATE OR REPLACE VIEW order_statistics AS
SELECT 
    COUNT(*) as total_orders,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_orders,
    SUM(CASE WHEN status = 'processing' THEN 1 ELSE 0 END) as processing_orders,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_orders,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END), 0) as total_revenue,
    COALESCE(AVG(CASE WHEN status = 'completed' THEN total ELSE NULL END), 0) as average_order_value
FROM orders;

-- Daily Sales View
CREATE OR REPLACE VIEW daily_sales AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_orders,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
    COALESCE(SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END), 0) as revenue
FROM orders
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC;

-- Popular Products View
CREATE OR REPLACE VIEW popular_products AS
SELECT 
    p.id,
    p.name,
    p.category,
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'completed'
GROUP BY p.id, p.name, p.category
ORDER BY total_quantity_sold DESC;

-- ============================================
-- Triggers for Auto-Update Timestamps
-- ============================================

-- PostgreSQL Trigger Function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to all tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Indexes for Performance
-- ============================================

-- Composite indexes for common queries
CREATE INDEX idx_products_category_available ON products(category, is_available);
CREATE INDEX idx_orders_status_created ON orders(status, created_at);
CREATE INDEX idx_orders_date_status ON orders(DATE(created_at), status);

-- Full-text search indexes (PostgreSQL)
-- CREATE INDEX idx_products_search ON products USING gin(to_tsvector('english', name || ' ' || description));
-- CREATE INDEX idx_categories_search ON categories USING gin(to_tsvector('english', name || ' ' || description));

-- ============================================
-- Comments for Documentation
-- ============================================

COMMENT ON TABLE users IS 'User accounts for authentication and authorization';
COMMENT ON TABLE categories IS 'Product categories for organizing menu items';
COMMENT ON TABLE products IS 'Menu items/products available for sale';
COMMENT ON TABLE orders IS 'Customer orders with payment information';
COMMENT ON TABLE order_items IS 'Individual items within each order';

COMMENT ON COLUMN users.outlet_ids IS 'JSON array of outlet IDs the user has access to (empty = all outlets)';
COMMENT ON COLUMN orders.order_type IS 'Type of order: Dine-in, Takeaway, or Delivery';
COMMENT ON COLUMN orders.status IS 'Order status: pending, processing, completed, or cancelled';
