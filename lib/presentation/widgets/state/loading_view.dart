// Displays a centered progress indicator.
import 'package:flutter/material.dart';

/// General purpose loading widget for asynchronous states.
class LoadingView extends StatelessWidget {
  /// Creates a new [LoadingView].
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
