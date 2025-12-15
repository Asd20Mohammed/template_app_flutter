import 'package:flutter/material.dart';
import 'package:template_app/src/core/utils/responsive_size.dart';
import 'package:get/get.dart';

import '/src/core/language/app_strings.dart';
import 'auto_direction_text.dart';

class SubmitButton extends StatelessWidget {
  final String? submitText;
  final VoidCallback? onTab;
  final Color? color;
  final IconData? icon;
  final TextStyle? style;

  const SubmitButton({
    super.key,
    this.submitText,
    this.onTab,
    this.color,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: onTab,
      height: 45.sp,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: color ?? Theme.of(context).primaryColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: Colors.white),
            AutoDirectionText(
              submitText ?? AppStrings.submit.tr.capitalizeFirst!,
              style:
                  style ??
                  Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
