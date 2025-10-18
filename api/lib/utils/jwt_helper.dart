import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../config/environment.dart';

class JwtHelper {
  static String generateToken(String userId, String username, String role) {
    final jwt = JWT(
      {
        'userId': userId,
        'username': username,
        'role': role,
        'iat': DateTime.now().millisecondsSinceEpoch,
      },
    );

    return jwt.sign(
      SecretKey(Environment.jwtSecret),
      expiresIn: Duration(hours: Environment.jwtExpirationHours),
    );
  }

  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Environment.jwtSecret));
      return jwt.payload as Map<String, dynamic>;
    } on JWTExpiredException {
      return null;
    } on JWTException {
      return null;
    }
  }

  static String? getUserIdFromToken(String token) {
    final payload = verifyToken(token);
    return payload?['userId'] as String?;
  }

  static String? getRoleFromToken(String token) {
    final payload = verifyToken(token);
    return payload?['role'] as String?;
  }
}
