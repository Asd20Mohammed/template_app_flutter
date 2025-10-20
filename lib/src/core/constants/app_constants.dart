// Groups general constant values reused across the app.
class AppConstants {
  /// Prevents instantiation.
  const AppConstants._();

  /// Key used for storing the theme preference.
  static const themePreferenceKey = 'theme_mode';

  /// Key used for storing the notification preference.
  static const notificationPreferenceKey = 'notifications_enabled';

  /// Key used for storing the locale preference.
  static const localePreferenceKey = 'locale_code';

  /// Key used for storing the preferred color seed.
  static const colorSeedPreferenceKey = 'color_seed';

  /// Key used for storing the text scale factor.
  static const textScalePreferenceKey = 'text_scale';

  /// Key used for storing the layout scale factor.
  static const layoutScalePreferenceKey = 'layout_scale';
}
