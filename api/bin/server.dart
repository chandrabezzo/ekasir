import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import '../lib/config/environment.dart';
import '../lib/routes.dart';

void main() async {
  // Initialize environment variables
  Environment.init();

  // Create app routes
  final appRoutes = AppRoutes();
  final handler = appRoutes.handler;

  // Start server
  final server = await shelf_io.serve(
    handler,
    Environment.host,
    Environment.port,
  );

  // Print server info
  print('╔════════════════════════════════════════════════════════╗');
  print('║                                                        ║');
  print('║              e-Kasir API Server                        ║');
  print('║                                                        ║');
  print('╚════════════════════════════════════════════════════════╝');
  print('');
  print('🚀 Server started successfully!');
  print('📍 URL: http://${server.address.host}:${server.port}');
  print('🌍 Environment: ${Environment.environment}');
  print('⏰ Started at: ${DateTime.now().toIso8601String()}');
  print('');
  print('📚 API Documentation:');
  print('   Health Check: GET /health');
  print('   Authentication: POST /api/auth/login');
  print('   Products: /api/products');
  print('   Categories: /api/categories');
  print('   Orders: /api/orders');
  print('   Users: /api/users');
  print('');
  print('👥 Default Users:');
  print('   Admin: admin / admin123');
  print('   Cashier: cashier / cashier123');
  print('');
  print('Press Ctrl+C to stop the server');
  print('═══════════════════════════════════════════════════════');

  // Graceful shutdown
  ProcessSignal.sigint.watch().listen((signal) async {
    print('\n🛑 Shutting down server...');
    await server.close(force: true);
    print('✅ Server stopped');
    exit(0);
  });
}
