// Bloc coordinating draft CRUD operations.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:template_app/src/features/drafts/domain/entities/draft_entry.dart';
import 'package:template_app/src/features/drafts/domain/repositories/draft_repository.dart';

part 'draft_event.dart';
part 'draft_state.dart';

/// Manages offline drafts for the dashboard.
class DraftBloc extends Bloc<DraftEvent, DraftState> {
  /// Creates a new [DraftBloc].
  DraftBloc(this._repository) : super(const DraftState.initial()) {
    on<DraftLoadRequested>(_onLoadRequested);
    on<DraftCreateRequested>(_onCreateRequested);
    on<DraftDeleteRequested>(_onDeleteRequested);
  }

  final DraftRepository _repository;
  final Uuid _uuid = const Uuid();

  Future<void> _onLoadRequested(
    DraftLoadRequested event,
    Emitter<DraftState> emit,
  ) async {
    emit(state.copyWith(status: DraftStatus.loading));
    try {
      final drafts = await _repository.fetchDrafts();
      emit(state.copyWith(status: DraftStatus.success, drafts: drafts));
    } catch (error) {
      emit(state.copyWith(status: DraftStatus.failure, errorMessage: '$error'));
    }
  }

  Future<void> _onCreateRequested(
    DraftCreateRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final draft = DraftEntry(
        id: _uuid.v4(),
        title: event.title,
        description: event.description,
        createdAt: now,
        updatedAt: now,
      );
      await _repository.saveDraft(draft);
      final updatedDrafts = List<DraftEntry>.from(state.drafts)..add(draft);
      emit(state.copyWith(drafts: updatedDrafts));
    } catch (error) {
      emit(state.copyWith(status: DraftStatus.failure, errorMessage: '$error'));
    }
  }

  Future<void> _onDeleteRequested(
    DraftDeleteRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      await _repository.deleteDraft(event.id);
      final updatedDrafts = state.drafts
          .where((entry) => entry.id != event.id)
          .toList();
      emit(state.copyWith(drafts: updatedDrafts));
    } catch (error) {
      emit(state.copyWith(status: DraftStatus.failure, errorMessage: '$error'));
    }
  }
}
