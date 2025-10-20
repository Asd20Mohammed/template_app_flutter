part of 'draft_bloc.dart';

/// Base class for draft related events.
abstract class DraftEvent extends Equatable {
  /// Creates a new [DraftEvent].
  const DraftEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the bloc to load drafts from storage.
class DraftLoadRequested extends DraftEvent {
  /// Creates a new load request event.
  const DraftLoadRequested();
}

/// Requests creation of a new draft entry.
class DraftCreateRequested extends DraftEvent {
  /// Creates a new draft creation event.
  const DraftCreateRequested({required this.title, required this.description});

  /// Title for the new draft.
  final String title;

  /// Description for the new draft.
  final String description;

  @override
  List<Object?> get props => [title, description];
}

/// Requests deletion of a specific draft entry by [id].
class DraftDeleteRequested extends DraftEvent {
  /// Creates a new delete event.
  const DraftDeleteRequested({required this.id});

  /// The identifier of the draft to remove.
  final String id;

  @override
  List<Object?> get props => [id];
}
