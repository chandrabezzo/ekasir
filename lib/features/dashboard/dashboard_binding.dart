import 'package:ekasir/features/dashboard/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Auth check is handled by AuthMiddleware
    Get.put(DashboardController());
  }
}
