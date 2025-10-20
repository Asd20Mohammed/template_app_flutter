// Coordinates feature flags and domain specific toggles.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/features/feature_flags/domain/repositories/feature_repository.dart';

/// Base definition for feature events.
abstract class FeatureEvent extends Equatable {
  /// Creates a new feature event.
  const FeatureEvent();

  @override
  List<Object?> get props => [];
}

/// Requests a feature flag to be updated.
class FeatureFlagChanged extends FeatureEvent {
  /// Creates a feature flag change event.
  const FeatureFlagChanged({required this.featureKey, required this.enabled});

  /// The identifier of the feature flag.
  final String featureKey;

  /// Whether the feature should be active.
  final bool enabled;

  @override
  List<Object?> get props => [featureKey, enabled];
}

/// Requests the latest feature flags from persistence.
class FeatureFlagsRequested extends FeatureEvent {
  /// Creates a load request event.
  const FeatureFlagsRequested();
}

/// Holds the current state of feature flags.
class FeatureState extends Equatable {
  /// Creates a new [FeatureState].
  const FeatureState({required this.flags});

  /// Map of feature keys to their enabled status.
  final Map<String, bool> flags;

  /// Provides the initial feature set with sane defaults.
  factory FeatureState.initial() => const FeatureState(flags: {});

  /// Copies the current state while optionally replacing the flags map.
  FeatureState copyWith({Map<String, bool>? flags}) {
    return FeatureState(flags: flags ?? this.flags);
  }

  @override
  List<Object?> get props => [flags];
}

/// Manages feature flags that drive conditional UI and logic.
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  /// Creates a new [FeatureBloc].
  FeatureBloc({required FeatureRepository featureRepository})
    : _featureRepository = featureRepository,
      super(FeatureState.initial()) {
    on<FeatureFlagsRequested>(_onFlagsRequested);
    on<FeatureFlagChanged>(_onFeatureFlagChanged);
  }

  final FeatureRepository _featureRepository;

  /// Loads flags from the repository.
  Future<void> _onFlagsRequested(
    FeatureFlagsRequested event,
    Emitter<FeatureState> emit,
  ) async {
    final flags = await _featureRepository.loadFlags();
    emit(state.copyWith(flags: flags));
  }

  /// Applies the feature flag update to the state map.
  Future<void> _onFeatureFlagChanged(
    FeatureFlagChanged event,
    Emitter<FeatureState> emit,
  ) async {
    final updatedFlags = Map<String, bool>.from(state.flags)
      ..[event.featureKey] = event.enabled;
    await _featureRepository.updateFlag(event.featureKey, event.enabled);
    emit(state.copyWith(flags: updatedFlags));
  }
}
