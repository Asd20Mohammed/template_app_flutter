// Provides minimal localization and translation management.
import 'package:flutter/widgets.dart';

/// Manages supported locales and translation lookups.
class LocalizationManager extends ChangeNotifier {
  /// Creates a new [LocalizationManager].
  LocalizationManager({
    Locale? initialLocale,
    Map<String, Map<String, String>>? translations,
  }) : _locale = initialLocale ?? const Locale('en'),
       _translations =
           translations ??
           {
             'en': {'app_title': 'Template App', 'welcome': 'Welcome'},
             'ar': {'app_title': 'تطبيق القالب', 'welcome': 'أهلاً بك'},
           };

  Locale _locale;
  final Map<String, Map<String, String>> _translations;

  /// Returns the currently active locale.
  Locale get locale => _locale;

  /// Updates the active locale and notifies listeners.
  void updateLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  /// Resolves a translation string by [key].
  String translate(String key) {
    final languageTranslations = _translations[_locale.languageCode];
    if (languageTranslations == null) {
      return key;
    }
    return languageTranslations[key] ?? key;
  }
}
