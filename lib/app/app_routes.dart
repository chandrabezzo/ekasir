import 'package:ekasir/features/order/order_binding.dart';
import 'package:ekasir/features/order/order_page.dart';
import 'package:get/get.dart';

import '../features/auth/login_page.dart';
import '../features/dashboard/dashboard_binding.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/dashboard/pages/order_detail_page.dart';
import '../features/dashboard/pages/qr_generator_page.dart';
import 'middlewares/auth_middleware.dart';

/// OrderPage is the default entry point (public access)
/// Dashboard and related pages require authentication via AuthMiddleware
final initialRoute = OrderPage.routeName;

final routes = [
  // Public routes
  GetPage(
    name: OrderPage.routeName,
    page: () => const OrderPage(),
    binding: OrderBinding(),
  ),
  GetPage(
    name: LoginPage.routeName,
    page: () => const LoginPage(),
  ),
  
  // Protected routes (require authentication)
  GetPage(
    name: DashboardPage.routeName,
    page: () => const DashboardPage(),
    binding: DashboardBinding(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: OrderDetailPage.routeName,
    page: () => OrderDetailPage(),
    binding: DashboardBinding(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: QrGeneratePage.routeName,
    page: () => const QrGeneratePage(),
    middlewares: [AuthMiddleware()],
  ),
];
