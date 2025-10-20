// Listens to network connectivity changes for the entire application.
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Describes the network status for the UI.
enum NetworkStatus { connected, disconnected, unknown }

/// Base class for network related events.
abstract class NetworkEvent extends Equatable {
  /// Creates a new network event.
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers a one-time connectivity check.
class NetworkCheckRequested extends NetworkEvent {
  /// Creates a connectivity check request.
  const NetworkCheckRequested();
}

/// Notifies the bloc about connectivity changes.
class NetworkStatusUpdated extends NetworkEvent {
  /// Creates a status update event.
  const NetworkStatusUpdated(this.status);

  /// The new network status.
  final NetworkStatus status;

  @override
  List<Object?> get props => [status];
}

/// Immutable representation of the network state.
class NetworkState extends Equatable {
  /// Creates a new [NetworkState].
  const NetworkState({required this.status});

  /// The current connectivity status.
  final NetworkStatus status;

  /// Returns the initial unknown state.
  factory NetworkState.initial() =>
      const NetworkState(status: NetworkStatus.unknown);

  /// Creates a copy with optional overrides.
  NetworkState copyWith({NetworkStatus? status}) {
    return NetworkState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

/// Bloc responsible for reacting to connectivity changes.
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  /// Creates a new [NetworkBloc] and starts listening to updates.
  NetworkBloc({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(NetworkState.initial()) {
    on<NetworkCheckRequested>(_onCheckRequested);
    on<NetworkStatusUpdated>(_onStatusUpdated);
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final status = _mapResultsToStatus(results);
      add(NetworkStatusUpdated(status));
    });
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Cancels the stream subscription when the bloc closes.
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  /// Performs a manual connectivity check.
  Future<void> _onCheckRequested(
    NetworkCheckRequested event,
    Emitter<NetworkState> emit,
  ) async {
    final results = await _connectivity.checkConnectivity();
    emit(state.copyWith(status: _mapResultsToStatus(results)));
  }

  /// Updates the state when a new connectivity status is reported.
  void _onStatusUpdated(
    NetworkStatusUpdated event,
    Emitter<NetworkState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  NetworkStatus _mapResultsToStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return NetworkStatus.unknown;
    }
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );
    return hasConnection ? NetworkStatus.connected : NetworkStatus.disconnected;
  }
}
