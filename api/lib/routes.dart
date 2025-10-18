import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'handlers/auth_handler.dart';
import 'handlers/product_handler.dart';
import 'handlers/category_handler.dart';
import 'handlers/order_handler.dart';
import 'handlers/user_handler.dart';
import 'repositories/user_repository.dart';
import 'repositories/product_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/order_repository.dart';
import 'middleware/auth_middleware.dart';
import 'middleware/logger_middleware.dart';
import 'utils/response_helper.dart';

class AppRoutes {
  late final UserRepository userRepository;
  late final ProductRepository productRepository;
  late final CategoryRepository categoryRepository;
  late final OrderRepository orderRepository;

  late final AuthHandler authHandler;
  late final ProductHandler productHandler;
  late final CategoryHandler categoryHandler;
  late final OrderHandler orderHandler;
  late final UserHandler userHandler;

  AppRoutes() {
    // Initialize repositories
    userRepository = UserRepository();
    productRepository = ProductRepository();
    categoryRepository = CategoryRepository();
    orderRepository = OrderRepository();

    // Initialize handlers
    authHandler = AuthHandler(userRepository);
    productHandler = ProductHandler(productRepository);
    categoryHandler = CategoryHandler(categoryRepository);
    orderHandler = OrderHandler(orderRepository);
    userHandler = UserHandler(userRepository);
  }

  Handler get handler {
    final router = Router();

    // Health check
    router.get('/health', (Request request) {
      return ResponseHelper.success(
        data: {
          'status': 'healthy',
          'timestamp': DateTime.now().toIso8601String(),
        },
        message: 'Server is running',
      );
    });

    // API routes
    router.mount('/api/auth', authHandler.router);
    
    // Protected routes - require authentication
    router.mount(
      '/api/products',
      Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler(productHandler.router),
    );

    router.mount(
      '/api/categories',
      Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler(categoryHandler.router),
    );

    router.mount(
      '/api/orders',
      Pipeline()
          .addMiddleware(authMiddleware())
          .addHandler(orderHandler.router),
    );

    router.mount(
      '/api/users',
      Pipeline()
          .addMiddleware(authMiddleware())
          .addMiddleware(adminMiddleware())
          .addHandler(userHandler.router),
    );

    // 404 handler
    router.all('/<ignored|.*>', (Request request) {
      return ResponseHelper.notFound('Endpoint not found');
    });

    return Pipeline()
        .addMiddleware(loggerMiddleware())
        .addMiddleware(corsHeaders())
        .addHandler(router);
  }

  // CORS middleware
  Middleware corsHeaders() {
    return (Handler innerHandler) {
      return (Request request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: _corsHeaders);
        }

        final response = await innerHandler(request);
        return response.change(headers: _corsHeaders);
      };
    };
  }

  final _corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers':
        'Origin, Content-Type, Accept, Authorization',
  };
}
