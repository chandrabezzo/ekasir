# Quick Start Guide

## Prerequisites

- **Dart SDK** >= 3.0.0 ([Install Dart](https://dart.dev/get-dart))

## Installation & Running

### Option 1: Using Shell Script (Recommended)

```bash
cd api
chmod +x run.sh
./run.sh
```

### Option 2: Manual Steps

```bash
# 1. Navigate to api directory
cd api

# 2. Install dependencies
dart pub get

# 3. Run the server
dart run bin/server.dart
```

## First Time Setup

1. **Configure Environment Variables**
   - The `.env` file is already created with default values
   - For production, update `JWT_SECRET` and other settings

2. **Default User Credentials**
   - **Admin**: `admin` / `admin123`
   - **Cashier**: `cashier` / `cashier123`

## Testing the API

### 1. Health Check
```bash
curl http://localhost:8080/health
```

Expected response:
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "timestamp": "2024-10-18T12:00:00.000Z"
  },
  "message": "Server is running"
}
```

### 2. Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

Save the `token` from the response.

### 3. Get Products (Protected Route)
```bash
curl -X GET http://localhost:8080/api/products \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Common Issues

### Port Already in Use
```bash
# Change PORT in .env file
PORT=8081
```

### Dependencies Not Found
```bash
# Clear and reinstall dependencies
rm -rf .dart_tool
dart pub get
```

## Next Steps

1. **Read API Documentation**: See `API_EXAMPLES.md` for detailed endpoint examples
2. **Integrate with Flutter App**: Update API base URL in your Flutter app
3. **Database Integration**: Replace in-memory storage with PostgreSQL/MySQL
4. **Deploy**: Deploy to your preferred hosting service

## Development Tips

### Hot Reload
The server doesn't support hot reload. Restart it after code changes:
```bash
# Press Ctrl+C to stop
# Then run again
dart run bin/server.dart
```

### Logging
All requests are logged with:
- Timestamp
- Method
- URL
- Status code
- Duration

### CORS
CORS is enabled for all origins (`*`). Configure in `lib/routes.dart` for production.

## Production Deployment

1. **Update Environment Variables**
```bash
ENVIRONMENT=production
JWT_SECRET=your-strong-secret-key-here
```

2. **Use Process Manager** (PM2, systemd, etc.)
```bash
# Example with PM2
pm2 start "dart run bin/server.dart" --name ekasir-api
```

3. **Reverse Proxy** (Nginx, Apache)
```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Support

For issues or questions:
1. Check `README.md` for full documentation
2. Review `API_EXAMPLES.md` for usage examples
3. Check server logs for error details
