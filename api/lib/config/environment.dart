import 'dart:io';
import 'package:dotenv/dotenv.dart';

class Environment {
  static late DotEnv _env;
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _env = DotEnv()..load();
    _initialized = true;
  }

  static String get host => _env['HOST'] ?? '0.0.0.0';
  static int get port => int.parse(_env['PORT'] ?? '8080');
  static String get jwtSecret => _env['JWT_SECRET'] ?? 'default-secret-key';
  static int get jwtExpirationHours =>
      int.parse(_env['JWT_EXPIRATION_HOURS'] ?? '24');
  static String get environment => _env['ENVIRONMENT'] ?? 'development';

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}
