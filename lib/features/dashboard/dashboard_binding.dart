import 'package:ekasir/features/dashboard/dashboard_controller.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';
import '../auth/login_page.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Check if user is authenticated before initializing dashboard
    final authController = Get.find<AuthController>();
    
    if (!authController.isLoggedIn) {
      // Redirect to login if not authenticated
      Future.microtask(() => Get.offAllNamed(LoginPage.routeName));
      return;
    }
    
    Get.put(DashboardController());
  }
}
