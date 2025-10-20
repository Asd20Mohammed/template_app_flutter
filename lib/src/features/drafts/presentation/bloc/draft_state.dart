part of 'draft_bloc.dart';

/// Represents the status of draft operations.
enum DraftStatus { initial, loading, success, failure }

/// Immutable state for [DraftBloc].
class DraftState extends Equatable {
  /// Creates a new [DraftState].
  const DraftState({
    required this.status,
    required this.drafts,
    this.errorMessage,
  });

  /// Initial state factory.
  const DraftState.initial()
    : this(status: DraftStatus.initial, drafts: const []);

  /// Current status of the bloc.
  final DraftStatus status;

  /// Collection of locally stored drafts.
  final List<DraftEntry> drafts;

  /// Optional description of the last failure.
  final String? errorMessage;

  /// Returns a copy with optional overrides.
  DraftState copyWith({
    DraftStatus? status,
    List<DraftEntry>? drafts,
    String? errorMessage,
  }) {
    return DraftState(
      status: status ?? this.status,
      drafts: drafts ?? this.drafts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, drafts, errorMessage];
}
