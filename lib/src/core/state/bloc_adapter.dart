// Adapter to use Bloc with the abstract state management layer.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state_notifier.dart';

/// Adapter that wraps a Bloc to implement StateNotifier interface.
class BlocAdapter<E, S> implements StateNotifier<S> {
  /// Creates a new [BlocAdapter] wrapping the given bloc.
  BlocAdapter(this._bloc);

  final Bloc<E, S> _bloc;

  @override
  S get state => _bloc.state;

  @override
  Stream<S> get stream => _bloc.stream;

  @override
  void emit(S newState) {
    // Bloc doesn't allow direct emit from outside
    // Use events instead
    throw UnsupportedError(
      'Cannot emit state directly on Bloc. Use events instead.',
    );
  }

  /// Adds an event to the bloc.
  void add(E event) {
    _bloc.add(event);
  }

  @override
  void dispose() {
    _bloc.close();
  }
}

/// Extension to easily create adapter from Bloc.
extension BlocAdapterExtension<E, S> on Bloc<E, S> {
  /// Creates a StateNotifier adapter for this bloc.
  BlocAdapter<E, S> toAdapter() => BlocAdapter(this);
}
