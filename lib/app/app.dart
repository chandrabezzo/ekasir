import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_binding.dart';
import 'app_controller.dart';
import 'app_routes.dart';
import 'constant/local_keys.dart';
import 'i18n/strings.dart';
import 'i18n/translation_service.dart';
import 'styles/app_style.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(sharedPreferences: Get.find<SharedPreferences>()),
      builder: (controller) => GetMaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        enableLog: kDebugMode,
        // logWriterCallback: !kIsWeb
        //     ? (message, {isError = false}) =>
        //         FirebaseCrashlytics.instance.log(message)
        //     : null,
        onInit: () async {
          final sharedPrefs = await SharedPreferences.getInstance();
          final locale = sharedPrefs.getString(LocalKeys.locale);

          switch (locale) {
            case 'en':
              Get.updateLocale(TranslationService.localizationEn);
              break;
            case 'id':
              Get.updateLocale(TranslationService.localizationId);
              break;
            default:
              Get.updateLocale(TranslationService.fallbackLocale);
          }

          Get.changeThemeMode(ThemeMode.system);
        },
        title: Strings.appName.tr,
        initialRoute: controller.initialRoute(),
        initialBinding: AppBinding(),
        getPages: routes,
        theme: AppStyles.lightTheme(context),
        darkTheme: AppStyles.darkTheme(context),
        themeMode: ThemeMode.system,
        locale: TranslationService.locale(Get.find<SharedPreferences>()),
        localizationsDelegates: TranslationService.delegates,
        supportedLocales: TranslationService.supportedLocales,
        fallbackLocale: TranslationService.fallbackLocale,
        translations: TranslationService(),
      ),
    );
  }
}
