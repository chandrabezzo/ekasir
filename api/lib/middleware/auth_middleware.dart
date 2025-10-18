import 'package:shelf/shelf.dart';
import '../utils/jwt_helper.dart';
import '../utils/response_helper.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return ResponseHelper.unauthorized('Missing or invalid authorization header');
      }

      final token = authHeader.substring(7);
      final payload = JwtHelper.verifyToken(token);

      if (payload == null) {
        return ResponseHelper.unauthorized('Invalid or expired token');
      }

      // Add user info to request context
      final updatedRequest = request.change(context: {
        'userId': payload['userId'],
        'username': payload['username'],
        'role': payload['role'],
      });

      return await innerHandler(updatedRequest);
    };
  };
}

// Admin-only middleware
Middleware adminMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final role = request.context['role'] as String?;

      if (role != 'admin') {
        return ResponseHelper.forbidden('Admin access required');
      }

      return await innerHandler(request);
    };
  };
}
