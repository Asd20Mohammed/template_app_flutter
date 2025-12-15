import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/ui_helpers.dart';

Future buildBottomSheet({
  required Widget widget,
  EdgeInsets? padding,
  Color? backgroundColor,
  double radius = 16.0,
  double? bottomRadius,
  double? maxHeight,
  required BuildContext context,
}) {
  return Get.bottomSheet(
    SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              maxHeight ?? Get.height - UiHelper.appBarSizeHeight.height * 2,
        ),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: widget,
        ),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(radius),
        topLeft: Radius.circular(radius),
        bottomRight: Radius.circular(bottomRadius ?? radius),
        bottomLeft: Radius.circular(bottomRadius ?? radius),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    isDismissible: true,
    persistent: false,
    // ignoreSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
  );
}
