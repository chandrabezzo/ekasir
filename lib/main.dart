import 'dart:async';

import 'package:ekasir/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final sharedPrefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPrefs, permanent: true);

    runApp(App());
  }, (error, stack) => debugPrint(error.toString()));
}
