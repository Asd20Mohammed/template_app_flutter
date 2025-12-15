// Auto-size-text import removed
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auto_direction_text.dart';

class HeaderTitleWidget extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final Color? bgColor;
  final EdgeInsets? padding;

  const HeaderTitleWidget({
    super.key,
    this.text,
    this.style,
    this.bgColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: bgColor ?? Colors.grey.shade200,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoDirectionText(text!, style: style ?? Get.textTheme.titleMedium),
        ],
      ),
    );
  }
}
