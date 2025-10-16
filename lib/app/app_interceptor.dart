import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:ekasir/features/order/order_page.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'constant/local_keys.dart';
import 'i18n/translation_service.dart';

class AppInterceptor extends InterceptorsWrapper {
  final _sharedPreferences = Get.find<SharedPreferences>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final params = options.queryParameters;
    final paramsContainsAmz = params.entries.firstWhereOrNull(
      (value) => value.key.toLowerCase().contains('amz'),
    );
    if (paramsContainsAmz == null) {
      final tokenType = _sharedPreferences
          .getString(LocalKeys.tokenType)
          ?.capitalizeFirst;
      final token = _sharedPreferences.getString(LocalKeys.token);
      if (token != null) {
        options.headers[HttpHeaders.authorizationHeader] = '$tokenType $token';
      }

      options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
      options.headers[HttpHeaders.acceptHeader] = 'application/json';

      options.headers['Accept-Language'] = await acceptLanguage;
    }

    handler.next(options);
  }

  Future<String> get acceptLanguage async {
    final language = TranslationService.locale(_sharedPreferences);

    switch (language) {
      case TranslationService.localizationEn:
        return 'en';
      case TranslationService.localizationId:
        return 'id';
      default:
        return 'id';
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      redirectToLogin();
    }

    return handler.reject(err);
  }

  void redirectToLogin() {
    _sharedPreferences.remove(LocalKeys.token);
    Get.offAllNamed(OrderPage.routeName);
  }
}
