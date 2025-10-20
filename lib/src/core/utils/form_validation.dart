// Provides helper methods for validating complex forms.
import 'package:template_app/src/core/errors/models/form_error.dart';

/// Performs batch validation and throws when invalid.
class FormValidation {
  /// Validates a map of field validators with their corresponding values.
  static void validate(Map<String, String? Function()> validators) {
    final errors = <String, String>{};
    validators.forEach((field, validator) {
      final message = validator();
      if (message != null) {
        errors[field] = message;
      }
    });
    if (errors.isNotEmpty) {
      throw FormError(errors.values.first);
    }
  }
}
