// Handles asynchronous initialization before rendering the app.
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/app/di/service_locator.dart';
import 'package:template_app/src/core/logging/app_bloc_observer.dart';

/// Bootstraps the application before running the widget tree.
Future<void> bootstrap(Future<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await configureDependencies();
  final app = await builder();
  runApp(app);
}
