import 'package:ekasir/features/order/order_binding.dart';
import 'package:ekasir/features/order/order_page.dart';
import 'package:get/get.dart';

import '../features/dashboard/dashboard_binding.dart';
import '../features/dashboard/dashboard_page.dart';

final initialRoute = OrderPage.routeName;

final routes = [
  GetPage(
    name: OrderPage.routeName,
    page: () => const OrderPage(),
    binding: OrderBinding(),
  ),
  GetPage(
    name: DashboardPage.routeName,
    page: () => const DashboardPage(),
    binding: DashboardBinding(),
  ),
];
