// Specialized error for form validation issues.
import 'package:template_app/core/errors/app_error.dart';

/// Thrown when a form submission encounters invalid data.
class FormError extends AppError {
  /// Creates a new [FormError].
  FormError(super.message, {super.stackTrace});
}
