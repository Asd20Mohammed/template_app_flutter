import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLanguage {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  static bool get isArabic => Get.locale?.languageCode == 'ar';
  static bool get isEnglish => Get.locale?.languageCode == 'en';

  static TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  static void changeLanguage(String languageCode) {
    Get.updateLocale(Locale(languageCode));
  }
}

class AppLanguageController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('en').obs;

  void changeLanguage(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  bool get isArabic => currentLocale.value.languageCode == 'ar';
  bool get isEnglish => currentLocale.value.languageCode == 'en';
}
