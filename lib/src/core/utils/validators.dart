// Provides reusable input validation helpers for forms.
class Validators {
  /// Prevents instantiation.
  const Validators._();

  /// Validates that the provided [value] looks like an email address.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates that the [value] meets password complexity rules.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
