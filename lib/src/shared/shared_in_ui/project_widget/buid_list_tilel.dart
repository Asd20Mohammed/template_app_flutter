// Auto-size-text import removed
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../core/themes/app_colors.dart';
import '../shared/shared_styles.dart';
import 'auto_direction_text.dart';

class BuildListTile extends StatelessWidget {
  final IconData leadingIcon;
  final bool? trailingIcon;
  final Widget? trailing;

  final String title;
  final String? subtitle;
  final Callback onTap;
  final double? size;
  final Color? color;

  const BuildListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.trailingIcon,
    required this.onTap,
    this.color,
    this.size,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      shape: SharedStyle.roundedRectangleBorderShape(radius: 16.0),
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(leadingIcon, color: color ?? AppColors.primaryColor),
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AutoDirectionText(title.tr.capitalizeFirst!),
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoDirectionText(
                subtitle?.tr.capitalizeFirst! ?? "",
                style: theme.textTheme.bodySmall,
              ),
            )
          : null,
      onTap: onTap,
      horizontalTitleGap: 0,
      trailing: trailing ?? Visibility(
              visible: trailingIcon ?? true,
              child: Icon(Icons.arrow_forward_ios),
            ),
    );
  }
}
