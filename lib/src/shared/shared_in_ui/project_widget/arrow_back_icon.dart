import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArrowBackIcon extends StatelessWidget {
  final double? size;
  final Color? iconColor;
  final TextDirection? textDirection;
  final bool forward;

  const ArrowBackIcon({
    super.key,
    this.size,
    this.iconColor,
    this.textDirection,
    this.forward = false,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      (Get.locale != const Locale('en'))
          ? Icons.arrow_back_ios
          : Icons.arrow_forward_ios,
      size: size ?? 18,
      // color: iconColor ?? Theme.of(context).iconTheme.color,
      textDirection: textDirection,
      applyTextScaling: Platform.isIOS ? true : false,
    );
  }
}
