import 'dart:async';

import 'package:ekasir/app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Use path-based URL strategy for web (removes # from URLs)
    if (kIsWeb) {
      usePathUrlStrategy();
    }

    final sharedPrefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPrefs, permanent: true);

    runApp(App());
  }, (error, stack) => debugPrint(error.toString()));
}
