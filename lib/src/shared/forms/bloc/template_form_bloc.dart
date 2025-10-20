// Provides shared form validation state and interaction patterns.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents a generic form submission status.
enum FormStatus { idle, submitting, success, failure }

/// Base class for form events.
abstract class FormEvent extends Equatable {
  /// Creates a new form event.
  const FormEvent();

  @override
  List<Object?> get props => [];
}

/// Requests form submission with the provided payload.
class FormSubmitted extends FormEvent {
  /// Creates a submission event with a [payload].
  const FormSubmitted(this.payload);

  /// Arbitrary payload that can be interpreted by feature modules.
  final Map<String, dynamic> payload;

  @override
  List<Object?> get props => [payload];
}

/// Resets the form back to its initial state.
class FormReset extends FormEvent {
  /// Creates a reset event.
  const FormReset();
}

/// Represents the state of a template form view.
class TemplateFormState extends Equatable {
  /// Creates a new [TemplateFormState].
  const TemplateFormState({required this.status, required this.errors});

  /// The current state of the form submission.
  final FormStatus status;

  /// A map of field names to error messages.
  final Map<String, String> errors;

  /// Returns the initial form state.
  factory TemplateFormState.initial() =>
      const TemplateFormState(status: FormStatus.idle, errors: {});

  /// Creates a copy with optional overrides.
  TemplateFormState copyWith({
    FormStatus? status,
    Map<String, String>? errors,
  }) {
    return TemplateFormState(
      status: status ?? this.status,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [status, errors];
}

/// Shared bloc for handling form lifecycle events.
class TemplateFormBloc extends Bloc<FormEvent, TemplateFormState> {
  /// Creates a new [TemplateFormBloc].
  TemplateFormBloc() : super(TemplateFormState.initial()) {
    on<FormSubmitted>(_onFormSubmitted);
    on<FormReset>(_onFormReset);
  }

  /// Simulates a backend submission and emits outcomes accordingly.
  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<TemplateFormState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.submitting, errors: {}));
    await Future<void>.delayed(const Duration(milliseconds: 400));
    emit(state.copyWith(status: FormStatus.success));
  }

  /// Returns the form state to its initial configuration.
  void _onFormReset(FormReset event, Emitter<TemplateFormState> emit) {
    emit(TemplateFormState.initial());
  }
}
