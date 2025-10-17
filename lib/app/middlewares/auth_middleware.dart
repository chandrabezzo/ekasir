import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/auth_controller.dart';
import '../../features/auth/login_page.dart';

/// Middleware to protect routes that require authentication
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is not logged in, redirect to login page
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: LoginPage.routeName);
    }
    
    // User is authenticated, allow access
    return null;
  }
}
