// Provides formatting helpers for dates, numbers, and currency.
import 'package:intl/intl.dart';

/// Shared formatting utilities.
class Formatter {
  /// Prevents instantiation.
  const Formatter._();

  /// Formats a [date] into a human readable string.
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Formats a double [value] using a decimal pattern.
  static String formatNumber(double value) {
    return NumberFormat.decimalPattern().format(value);
  }

  /// Formats a currency [value] using the provided [currencyCode].
  static String formatCurrency(double value, {String currencyCode = 'USD'}) {
    return NumberFormat.simpleCurrency(name: currencyCode).format(value);
  }
}
