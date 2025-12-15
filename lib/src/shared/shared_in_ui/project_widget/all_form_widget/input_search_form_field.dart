import 'dart:async';
import '/src/shared/shared_in_ui/project_widget/all_form_widget/input_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InputSearchField extends StatefulWidget {
  final String keyName;
  final Function(String) startSearch;

  const InputSearchField({
    super.key,
    required this.keyName,
    required this.startSearch,
  });

  @override
  State<InputSearchField> createState() => _InputSearchFieldState();
}

class _InputSearchFieldState extends State<InputSearchField> {
  final Debouncer _debouncer = Debouncer();
  bool showSpin = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputTextFieldWidget(
            keyName: widget.keyName,
            onChange: (text) {
              if (text!.length >= 3) {
                _debouncer(() {
                  setState(() {
                    showSpin = !showSpin;
                  });
                });
              }
            },
          ),
        ),
        if (showSpin)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SpinKitRing(
              color: Theme.of(context).primaryColor,
              size: 24,
              lineWidth: 4.0,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  call(Function action) {
    _timer?.cancel();
    _timer = Timer(delay, action as void Function());
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
