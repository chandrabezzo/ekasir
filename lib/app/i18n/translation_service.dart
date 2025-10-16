import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/local_keys.dart';
import 'locales/en.dart';
import 'locales/id.dart';

class TranslationService extends Translations {
  static Locale locale(SharedPreferences prefs) {
    final locale = prefs.getString(LocalKeys.locale);
    switch (locale) {
      case 'en':
        return localizationEn;
      case 'id':
        return localizationId;
      default:
        return fallbackLocale;
    }
  }

  static const fallbackLocale = Locale('id');

  static const Locale localizationEn = Locale('en', 'EN');
  static const Locale localizationId = Locale('id', 'ID');

  static const List<Locale> supportedLocales = [localizationEn, localizationId];

  static const Iterable<LocalizationsDelegate<dynamic>> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static String name(SharedPreferences prefs) {
    final locale = prefs.getString(LocalKeys.locale);
    switch (locale) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return 'Bahasa Indonesia';
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
    localizationEn.languageCode: en,
    localizationId.languageCode: id,
  };
}
