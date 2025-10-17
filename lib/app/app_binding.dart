import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../features/auth/auth_controller.dart';
import 'app_interceptor.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthController first as it may be needed by other services
    Get.put(AuthController(), permanent: true);
    
    Get.put(client(), permanent: true);
  }

  static Dio client({String? baseUrl}) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        baseUrl: baseUrl ?? const String.fromEnvironment('baseUrl'),
      ),
    );
    dio.interceptors.add(AppInterceptor());
    return dio;
  }
}
