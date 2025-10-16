import 'package:ekasir/features/dashboard/dashboard_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/order/order_page.dart';
import 'constant/local_keys.dart';

class AppController extends GetxController {
  final SharedPreferences _sharedPreferences;

  AppController({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  String initialRoute({bool havePromotion = false}) {
    final token = _sharedPreferences.getString(LocalKeys.token);

    if (token != null) {
      return DashboardPage.routeName;
    } else {
      return OrderPage.routeName;
    }
  }
}
