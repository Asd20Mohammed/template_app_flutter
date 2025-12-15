import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/ui_helpers.dart';
import '../auto_direction_text.dart';
import '../image_widget/circular_cached_image.dart';

class CustomAppBar extends AppBar {
  final String? titleText;
  final String? imageUrl;
  final IconData? titleIcon;
  @override
  final bool automaticallyImplyLeading;
  final Color? color;
  final Color? textColor;

  CustomAppBar({
    super.key,
    String? title,
    this.titleText,
    this.imageUrl,
    super.actions,
    double? fontSize,
    this.automaticallyImplyLeading = true,
    this.color,
    this.textColor,
    this.titleIcon,
    super.bottom,
  }) : super(
         title: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             if (imageUrl != null)
               CircularCachedImageWidget(
                 url: imageUrl,
                 radius: 15,
               ),
             if (titleIcon != null)
               Icon(titleIcon)
             else if ((title ?? titleText) != null)
               AutoDirectionText(
                 (title ?? titleText)!.tr.capitalizeFirst!,
                 style: TextStyle(
                   fontWeight:
                       fontSize != null ? FontWeight.bold : FontWeight.w400,
                   fontSize: 17,
                 ),
               )
             else
               const SizedBox.shrink(),
           ],
         ),
         automaticallyImplyLeading: automaticallyImplyLeading,
         elevation: 0.3,
         toolbarHeight: UiHelper.appBarSizeHeight.height,
       );
}
