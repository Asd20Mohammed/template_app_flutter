import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool inScaffold;

  const LoadingWidget({super.key, this.inScaffold = true});

  @override
  Widget build(BuildContext context) {
    return inScaffold
        ? Scaffold(body: Center(child: UiHelper.spinKitProgressIndicator()))
        : Center(child: UiHelper.spinKitProgressIndicator());
  }
}
