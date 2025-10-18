# API Usage Examples

## Authentication

### 1. Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "uuid",
      "username": "admin",
      "name": "Administrator",
      "role": "admin",
      "outletIds": [],
      "outletName": "Main Outlet"
    }
  },
  "message": "Login successful"
}
```

### 2. Register New User
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "password": "password123",
    "name": "New User",
    "role": "cashier",
    "outletName": "Branch 1"
  }'
```

### 3. Get Current User
```bash
curl -X GET http://localhost:8080/api/auth/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Products/Menu

### 1. Get All Products
```bash
# Get all products
curl -X GET http://localhost:8080/api/products \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Filter by category
curl -X GET "http://localhost:8080/api/products?category=Food" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Filter by availability
curl -X GET "http://localhost:8080/api/products?available=true" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. Get Product by ID
```bash
curl -X GET http://localhost:8080/api/products/PRODUCT_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 3. Create Product
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Nasi Goreng Spesial",
    "description": "Nasi goreng dengan telur, ayam, dan sayuran",
    "price": 25000,
    "category": "Food",
    "imageUrl": "https://example.com/image.jpg",
    "isAvailable": true
  }'
```

### 4. Update Product
```bash
curl -X PUT http://localhost:8080/api/products/PRODUCT_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Nasi Goreng Super Spesial",
    "price": 30000,
    "isAvailable": true
  }'
```

### 5. Delete Product
```bash
curl -X DELETE http://localhost:8080/api/products/PRODUCT_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Categories

### 1. Get All Categories
```bash
# Get all categories
curl -X GET http://localhost:8080/api/categories \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get only active categories
curl -X GET "http://localhost:8080/api/categories?active=true" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. Create Category
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Appetizer",
    "description": "Pembuka selera",
    "iconName": "restaurant",
    "isActive": true
  }'
```

### 3. Update Category
```bash
curl -X PUT http://localhost:8080/api/categories/CATEGORY_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Appetizer & Starter",
    "description": "Hidangan pembuka",
    "isActive": true
  }'
```

### 4. Delete Category
```bash
curl -X DELETE http://localhost:8080/api/categories/CATEGORY_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Orders

### 1. Get All Orders
```bash
# Get all orders
curl -X GET http://localhost:8080/api/orders \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Filter by status
curl -X GET "http://localhost:8080/api/orders?status=pending" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Filter by customer phone
curl -X GET "http://localhost:8080/api/orders?customerPhone=08123456789" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Filter by date range
curl -X GET "http://localhost:8080/api/orders?startDate=2024-01-01T00:00:00Z&endDate=2024-12-31T23:59:59Z" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. Get Order Statistics
```bash
curl -X GET http://localhost:8080/api/orders/statistics \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total": 150,
    "pending": 10,
    "processing": 5,
    "completed": 130,
    "cancelled": 5,
    "totalRevenue": 15000000
  }
}
```

### 3. Create Order
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "John Doe",
    "customerPhone": "08123456789",
    "outletName": "Main Outlet",
    "tableNumber": "A5",
    "orderType": "Dine-in",
    "items": [
      {
        "productId": "product-id-1",
        "productName": "Nasi Goreng",
        "quantity": 2,
        "price": 25000,
        "notes": "Extra pedas"
      },
      {
        "productId": "product-id-2",
        "productName": "Es Teh",
        "quantity": 2,
        "price": 5000
      }
    ],
    "subtotal": 60000,
    "tax": 6000,
    "discount": 0,
    "total": 66000,
    "notes": "Segera"
  }'
```

### 4. Update Order Status
```bash
curl -X PUT http://localhost:8080/api/orders/ORDER_ID/status \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "processing"
  }'
```

**Available statuses:** `pending`, `processing`, `completed`, `cancelled`

### 5. Update Order
```bash
curl -X PUT http://localhost:8080/api/orders/ORDER_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tableNumber": "B3",
    "notes": "Updated notes"
  }'
```

### 6. Cancel Order
```bash
curl -X DELETE http://localhost:8080/api/orders/ORDER_ID \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Users (Admin Only)

### 1. Get All Users
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN"
```

### 2. Get User by ID
```bash
curl -X GET http://localhost:8080/api/users/USER_ID \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN"
```

### 3. Update User
```bash
curl -X PUT http://localhost:8080/api/users/USER_ID \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Name",
    "role": "cashier",
    "outletName": "Branch 2"
  }'
```

### 4. Delete User
```bash
curl -X DELETE http://localhost:8080/api/users/USER_ID \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN"
```

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "error": "Invalid input data",
  "code": "BAD_REQUEST"
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "error": "Invalid or expired token",
  "code": "UNAUTHORIZED"
}
```

### 403 Forbidden
```json
{
  "success": false,
  "error": "Admin access required",
  "code": "FORBIDDEN"
}
```

### 404 Not Found
```json
{
  "success": false,
  "error": "Resource not found",
  "code": "NOT_FOUND"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "error": "Internal server error",
  "code": "INTERNAL_ERROR"
}
```

## Testing with JavaScript/TypeScript

### Using Fetch API
```javascript
// Login
const login = async () => {
  const response = await fetch('http://localhost:8080/api/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      username: 'admin',
      password: 'admin123',
    }),
  });
  
  const data = await response.json();
  return data.data.token;
};

// Get products
const getProducts = async (token) => {
  const response = await fetch('http://localhost:8080/api/products', {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });
  
  const data = await response.json();
  return data.data;
};

// Create order
const createOrder = async (token, orderData) => {
  const response = await fetch('http://localhost:8080/api/orders', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify(orderData),
  });
  
  const data = await response.json();
  return data.data;
};
```

### Using Axios
```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
});

// Add token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Login
const login = async (username, password) => {
  const { data } = await api.post('/auth/login', { username, password });
  localStorage.setItem('token', data.data.token);
  return data.data;
};

// Get products
const getProducts = async () => {
  const { data } = await api.get('/products');
  return data.data;
};

// Create order
const createOrder = async (orderData) => {
  const { data } = await api.post('/orders', orderData);
  return data.data;
};
```
