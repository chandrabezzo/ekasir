-- ============================================
-- e-Kasir Seed Data
-- ============================================

-- Clear existing data (in correct order)
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM users;

-- ============================================
-- Seed Users
-- ============================================
-- Note: Passwords are BCrypt hashed
-- admin123 = $2b$10$8k1p3h9m4b.qR7dW1F5YXOGVqL8YWxvC/oJ5rE3K4dH8fW9mX2qKe
-- cashier123 = $2b$10$rQ4Z7H5mP8bW3xK6tL9jXeM2vY8nF4hR6kT3wL7mP9qX5yJ2bN4cC

INSERT INTO users (id, username, password, name, role, outlet_ids, outlet_name, created_at, updated_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'admin', '$2b$10$K7Zq3k2M9vR4xL6wN8jT.eH5yF9mP2bS7gW3xV8tR5nJ4kL6mH9qW', 'Administrator', 'admin', '[]', 'Main Outlet', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('550e8400-e29b-41d4-a716-446655440001', 'cashier', '$2b$10$L8Wp4l3N0wS5yM7xO9kU.fI6zG0nQ3cT8hX4yW9uS6oK5lM7nI0rX', 'Cashier User', 'cashier', '["outlet-1"]', 'Main Outlet', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('550e8400-e29b-41d4-a716-446655440002', 'manager', '$2b$10$M9Xq5m4O1xT6zN8yP0lV.gJ7aH1oR4dU9iY5zX0vT7pL6mN8oJ1sY', 'Store Manager', 'manager', '["outlet-1", "outlet-2"]', 'Main Outlet', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ============================================
-- Seed Categories
-- ============================================
INSERT INTO categories (id, name, description, icon_name, is_active, created_at, updated_at) VALUES
('cat-001', 'Food', 'Makanan utama dan lauk pauk', 'restaurant', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('cat-002', 'Beverage', 'Minuman panas dan dingin', 'local_cafe', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('cat-003', 'Snack', 'Camilan dan makanan ringan', 'fastfood', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('cat-004', 'Dessert', 'Makanan penutup dan pencuci mulut', 'cake', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('cat-005', 'Appetizer', 'Hidangan pembuka', 'lunch_dining', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ============================================
-- Seed Products
-- ============================================
INSERT INTO products (id, name, description, price, image_url, category, is_available, created_at, updated_at) VALUES
-- Food
('prod-001', 'Nasi Goreng Spesial', 'Nasi goreng dengan telur, ayam, dan sayuran', 25000.00, 'https://via.placeholder.com/300', 'Food', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-002', 'Mie Goreng', 'Mie goreng dengan topping ayam dan sayuran', 20000.00, 'https://via.placeholder.com/300', 'Food', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-003', 'Ayam Bakar', 'Ayam bakar dengan sambal dan lalapan', 35000.00, 'https://via.placeholder.com/300', 'Food', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-004', 'Soto Ayam', 'Soto ayam kuah kuning dengan nasi', 22000.00, 'https://via.placeholder.com/300', 'Food', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-005', 'Nasi Uduk', 'Nasi uduk komplit dengan ayam goreng', 28000.00, 'https://via.placeholder.com/300', 'Food', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Beverage
('prod-006', 'Es Teh Manis', 'Teh manis dingin segar', 5000.00, 'https://via.placeholder.com/300', 'Beverage', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-007', 'Kopi Hitam', 'Kopi hitam original tanpa gula', 10000.00, 'https://via.placeholder.com/300', 'Beverage', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-008', 'Es Jeruk', 'Jus jeruk segar dengan es', 12000.00, 'https://via.placeholder.com/300', 'Beverage', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-009', 'Cappuccino', 'Kopi cappuccino dengan foam susu', 18000.00, 'https://via.placeholder.com/300', 'Beverage', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-010', 'Jus Alpukat', 'Jus alpukat kental dengan cokelat', 15000.00, 'https://via.placeholder.com/300', 'Beverage', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Snack
('prod-011', 'Kentang Goreng', 'Kentang goreng crispy dengan saus', 15000.00, 'https://via.placeholder.com/300', 'Snack', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-012', 'Pisang Goreng', 'Pisang goreng crispy dengan keju', 12000.00, 'https://via.placeholder.com/300', 'Snack', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-013', 'Tahu Crispy', 'Tahu goreng crispy dengan saus kacang', 10000.00, 'https://via.placeholder.com/300', 'Snack', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-014', 'Lumpia Goreng', 'Lumpia goreng isi sayuran', 8000.00, 'https://via.placeholder.com/300', 'Snack', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Dessert
('prod-015', 'Es Krim Vanilla', 'Es krim vanilla premium', 12000.00, 'https://via.placeholder.com/300', 'Dessert', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-016', 'Puding Cokelat', 'Puding cokelat dengan vla', 10000.00, 'https://via.placeholder.com/300', 'Dessert', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-017', 'Brownies', 'Brownies cokelat dengan topping', 15000.00, 'https://via.placeholder.com/300', 'Dessert', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

-- Appetizer
('prod-018', 'Salad Sayur', 'Salad sayuran segar dengan dressing', 18000.00, 'https://via.placeholder.com/300', 'Appetizer', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-019', 'Soup Jagung', 'Soup jagung kental dengan telur', 15000.00, 'https://via.placeholder.com/300', 'Appetizer', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prod-020', 'Edamame', 'Kacang edamame rebus dengan garam', 12000.00, 'https://via.placeholder.com/300', 'Appetizer', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ============================================
-- Seed Sample Orders (for testing)
-- ============================================
INSERT INTO orders (id, order_number, customer_name, customer_phone, outlet_name, table_number, order_type, subtotal, tax, discount, total, status, notes, created_at, updated_at, completed_at) VALUES
('order-001', 'ORD-000001', 'John Doe', '081234567890', 'Main Outlet', 'A1', 'Dine-in', 50000.00, 5000.00, 0.00, 55000.00, 'completed', 'Extra pedas', CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days'),
('order-002', 'ORD-000002', 'Jane Smith', '081234567891', 'Main Outlet', 'B3', 'Dine-in', 85000.00, 8500.00, 5000.00, 88500.00, 'completed', NULL, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '1 day'),
('order-003', 'ORD-000003', 'Bob Wilson', '081234567892', 'Main Outlet', NULL, 'Takeaway', 42000.00, 4200.00, 0.00, 46200.00, 'processing', 'Bungkus terpisah', CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours', NULL),
('order-004', 'ORD-000004', 'Alice Brown', '081234567893', 'Main Outlet', 'C5', 'Dine-in', 67000.00, 6700.00, 10000.00, 63700.00, 'pending', NULL, CURRENT_TIMESTAMP - INTERVAL '30 minutes', CURRENT_TIMESTAMP - INTERVAL '30 minutes', NULL);

-- ============================================
-- Seed Order Items
-- ============================================
INSERT INTO order_items (id, order_id, product_id, product_name, quantity, price, notes, created_at) VALUES
-- Order 1 items
('item-001', 'order-001', 'prod-001', 'Nasi Goreng Spesial', 2, 25000.00, 'Extra pedas', CURRENT_TIMESTAMP - INTERVAL '2 days'),
('item-002', 'order-001', 'prod-006', 'Es Teh Manis', 2, 5000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '2 days'),

-- Order 2 items
('item-003', 'order-002', 'prod-003', 'Ayam Bakar', 2, 35000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '1 day'),
('item-004', 'order-002', 'prod-008', 'Es Jeruk', 2, 12000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '1 day'),
('item-005', 'order-002', 'prod-011', 'Kentang Goreng', 1, 15000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '1 day'),

-- Order 3 items
('item-006', 'order-003', 'prod-002', 'Mie Goreng', 2, 20000.00, 'Bungkus terpisah', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
('item-007', 'order-003', 'prod-007', 'Kopi Hitam', 2, 10000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '2 hours'),

-- Order 4 items
('item-008', 'order-004', 'prod-004', 'Soto Ayam', 2, 22000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
('item-009', 'order-004', 'prod-009', 'Cappuccino', 2, 18000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
('item-010', 'order-004', 'prod-012', 'Pisang Goreng', 1, 12000.00, NULL, CURRENT_TIMESTAMP - INTERVAL '30 minutes');

-- ============================================
-- Verify Seed Data
-- ============================================
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items;
