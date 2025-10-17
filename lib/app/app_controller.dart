import 'package:get/get.dart';

import '../features/order/order_page.dart';

class AppController extends GetxController {
  /// Returns the initial route for the app.
  /// OrderPage is publicly accessible without authentication
  String initialRoute() {
    return OrderPage.routeName;
  }
}
