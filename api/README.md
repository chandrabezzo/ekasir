# e-Kasir API Backend

RESTful API backend for e-Kasir POS application built with Dart Shelf framework.

## Features

- 🔐 **Authentication & Authorization** - JWT-based auth with role management
- 📦 **Product Management** - CRUD operations for menu items
- 📁 **Category Management** - Dynamic category system
- 🛒 **Order Management** - Complete order lifecycle
- 👥 **User Management** - User accounts and permissions
- 🔄 **Real-time Updates** - Support for order status updates
- 📊 **RESTful API** - Clean and consistent API design

## Tech Stack

- **Framework**: Shelf (Dart)
- **Auth**: JWT (JSON Web Tokens)
- **Password**: BCrypt hashing
- **CORS**: Enabled for web clients
- **Storage**: In-memory (ready for DB integration)

## Getting Started

### Prerequisites

- Dart SDK >= 3.0.0

### Installation

```bash
# Navigate to api directory
cd api

# Install dependencies
dart pub get

# Copy environment file
cp .env.example .env

# Run the server
dart run bin/server.dart
```

The API will start on `http://localhost:8080`

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/me` - Get current user

### Products/Menu
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get product by ID
- `POST /api/products` - Create product (auth required)
- `PUT /api/products/:id` - Update product (auth required)
- `DELETE /api/products/:id` - Delete product (auth required)

### Categories
- `GET /api/categories` - Get all categories
- `GET /api/categories/:id` - Get category by ID
- `POST /api/categories` - Create category (auth required)
- `PUT /api/categories/:id` - Update category (auth required)
- `DELETE /api/categories/:id` - Delete category (auth required)

### Orders
- `GET /api/orders` - Get all orders
- `GET /api/orders/:id` - Get order by ID
- `POST /api/orders` - Create new order
- `PUT /api/orders/:id` - Update order
- `PUT /api/orders/:id/status` - Update order status
- `DELETE /api/orders/:id` - Cancel order

### Users
- `GET /api/users` - Get all users (admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user (admin only)

## Environment Variables

```env
PORT=8080
HOST=0.0.0.0
JWT_SECRET=your-secret-key
JWT_EXPIRATION_HOURS=24
ENVIRONMENT=development
```

## Project Structure

```
api/
├── bin/
│   └── server.dart           # Server entry point
├── lib/
│   ├── config/
│   │   └── environment.dart  # Environment configuration
│   ├── models/               # Data models
│   ├── repositories/         # Data access layer
│   ├── handlers/             # Request handlers
│   ├── middleware/           # Middleware functions
│   ├── utils/                # Utilities
│   └── routes.dart           # Route definitions
├── .env                      # Environment variables
├── .env.example              # Example environment file
└── pubspec.yaml              # Dependencies
```

## Response Format

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

### Error Response
```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

## Authentication

Include JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## Development

```bash
# Run server
dart run bin/server.dart

# Run tests
dart test

# Format code
dart format .

# Analyze code
dart analyze
```

## Production Deployment

1. Set environment variables
2. Build the project
3. Run with production settings

```bash
ENVIRONMENT=production dart run bin/server.dart
```

## Future Enhancements

- [ ] PostgreSQL/MySQL database integration
- [ ] Redis caching
- [ ] WebSocket for real-time updates
- [ ] File upload for product images
- [ ] Rate limiting
- [ ] API documentation (Swagger)
- [ ] Logging system
- [ ] Monitoring and analytics

## License

Private - e-Kasir Project
