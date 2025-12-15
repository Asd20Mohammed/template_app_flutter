// Auto-size-text import removed
import 'package:flutter/material.dart';

import 'auto_direction_text.dart';

class ClickableTextWidget extends StatelessWidget {
  final VoidCallback onClick;
  final String? textToShow;
  final EdgeInsets? padding;

  // final bool withTranslate;
  final Color? textColor;

  const ClickableTextWidget({
    super.key,
    required this.onClick,
    required this.textToShow,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: AutoDirectionText(
        textToShow!,
        style: TextStyle(
          color: textColor ?? Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
