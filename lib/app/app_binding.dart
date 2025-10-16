import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'app_interceptor.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
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
