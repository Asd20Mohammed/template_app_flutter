// Abstract state management layer to allow switching between Bloc/GetX/etc.
import 'dart:async';

/// Abstract base class for state management.
/// This provides a common interface regardless of the underlying implementation.
abstract class StateNotifier<S> {
  /// Gets the current state.
  S get state;

  /// Stream of state changes.
  Stream<S> get stream;

  /// Updates the state.
  void emit(S newState);

  /// Disposes resources.
  void dispose();
}

/// Simple implementation of StateNotifier using streams.
class SimpleStateNotifier<S> implements StateNotifier<S> {
  /// Creates a new [SimpleStateNotifier] with initial state.
  SimpleStateNotifier(this._state);

  S _state;
  final _controller = StreamController<S>.broadcast();

  @override
  S get state => _state;

  @override
  Stream<S> get stream => _controller.stream;

  @override
  void emit(S newState) {
    _state = newState;
    _controller.add(newState);
  }

  @override
  void dispose() {
    _controller.close();
  }
}

/// Mixin to add state management capabilities to any class.
mixin StateMixin<S> {
  late final SimpleStateNotifier<S> _notifier;

  /// Initializes the state notifier with initial state.
  void initState(S initialState) {
    _notifier = SimpleStateNotifier(initialState);
  }

  /// Gets the current state.
  S get state => _notifier.state;

  /// Stream of state changes.
  Stream<S> get stateStream => _notifier.stream;

  /// Updates the state.
  void updateState(S newState) {
    _notifier.emit(newState);
  }

  /// Disposes resources.
  void disposeState() {
    _notifier.dispose();
  }
}
