import '/src/core/themes/app_colors.dart';
import '/src/core/themes/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedStyle {
  SharedStyle._();

  static BorderRadius customBorderRadius({required double radius}) =>
      BorderRadius.all(Radius.circular(radius));

  static roundedRectangleBorderShape({double radius = 8}) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  static BoxShadow primaryBoxShadow = BoxShadow(
    blurRadius: 16,
    spreadRadius: 2,
    color: ThemeHelper.isDarkMode ? Colors.black12 : Colors.black26,
    offset: const Offset(0, 4),
  );

  static defaultBoxDecoration({double radius = 8}) => BoxDecoration(
    color: ThemeHelper.adaptiveColor(
      lightColor: AppColors.scaffoldBackgroundColor,
      darkColor: AppColors.darkCardBackgroundColor,
    ),
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [primaryBoxShadow],
  );

  static BoxDecoration get filledDecoration => BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    color: ThemeHelper.adaptiveColor(
      lightColor: AppColors.inputFillColor,
      darkColor: AppColors.darkInputFillColor,
    ),
  );

  static filledBoxDecoration({double radius = 8}) => BoxDecoration(
    color: ThemeHelper.adaptiveColor(
      lightColor: AppColors.cardBackgroundColor,
      darkColor: AppColors.darkCardBackgroundColor,
    ),
    borderRadius: BorderRadius.circular(radius),
  );

  static BoxDecoration get filledRoundedDecoration => BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    color: ThemeHelper.adaptiveColor(
      lightColor: AppColors.inputFillColor,
      darkColor: AppColors.darkInputFillColor,
    ),
  );

  static InputDecoration buildFormDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    required BuildContext context,
  }) => InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    fillColor: ThemeHelper.adaptiveColor(
      lightColor: AppColors.inputFillColor,
      darkColor: AppColors.darkInputFillColor,
    ),
    filled: true,
    errorMaxLines: 2,
    hintText: hintText?.tr ?? '',
    hintStyle: Get.textTheme.bodySmall?.copyWith(
      color: ThemeHelper.adaptiveColor(
        lightColor: AppColors.hintColor,
        darkColor: AppColors.darkHintColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: ThemeHelper.adaptiveColor(
          lightColor: AppColors.primaryColor,
          darkColor: AppColors.darkPrimaryColor,
        ),
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
  );

  static const BoxDecoration boxDecorationWithRadiusAndShadow = BoxDecoration(
    // color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 10,
        spreadRadius: 0,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration disabledFieldDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: ThemeHelper.adaptiveColor(
      lightColor: Colors.grey[100]!,
      darkColor: Colors.grey[800]!,
    ),
  );

  static formBuilderWidgetDecoration({
    bool filled = true,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDense = true,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: ThemeHelper.adaptiveColor(
        lightColor: AppColors.inputFillColor,
        darkColor: AppColors.darkInputFillColor,
      ),
      filled: filled,
      labelText: labelText?.tr,
      labelStyle: Get.textTheme.titleMedium?.copyWith(
        color: ThemeHelper.adaptiveColor(
          lightColor: AppColors.hintColor,
          darkColor: AppColors.darkHintColor,
        ),
      ),
      errorMaxLines: 2,
      hintText: hintText?.tr,
      hintStyle: Get.textTheme.titleMedium?.copyWith(
        color: ThemeHelper.adaptiveColor(
          lightColor: AppColors.hintColor,
          darkColor: AppColors.darkHintColor,
        ),
      ),
      isDense: isDense,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: ThemeHelper.adaptiveColor(
            lightColor: AppColors.primaryColor,
            darkColor: AppColors.darkPrimaryColor,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}
