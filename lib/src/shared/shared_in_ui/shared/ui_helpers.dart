import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class UiHelper {
  UiHelper._();

  static Size appBarSizeHeight = AppBar().preferredSize;

  static const SizedBox horizontalSpaceTiny = SizedBox(width: 4.0);
  static const SizedBox horizontalSpaceSmall = SizedBox(width: 8.0);
  static const SizedBox horizontalSpaceMedium = SizedBox(width: 16.0);
  static const SizedBox horizontalSpaceLarge = SizedBox(width: 24.0);
  static const SizedBox horizontalSpaceMassive = SizedBox(width: 32.0);

  static const SizedBox verticalSpaceTiny = SizedBox(height: 4.0);
  static const SizedBox verticalSpaceSmall = SizedBox(height: 8.0);
  static const SizedBox verticalSpaceMedium = SizedBox(height: 16.0);
  static const SizedBox verticalSpaceLarge = SizedBox(height: 24.0);
  static const SizedBox verticalSpaceMassive = SizedBox(height: 32.0);

  static SizedBox verticalSpace(double height) => SizedBox(height: height);

  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  static Divider columnDivider({
    Color? color,
    double? height,
    double? indent,
    double? endIndent,
  }) {
    return Divider(
      color: color ?? Get.theme.cardColor,
      height: height,
      indent: indent,
      endIndent: endIndent,
    );
  }

  static const VerticalDivider rowDivider = VerticalDivider();
  static const SizedBox shrinkSizedBox = SizedBox.shrink();

  static Widget spinKitProgressIndicator({
    double spinKitSize = 50.0,
    Color? color,
  }) {
    final spinKit = Builder(
      builder: (context) {
        return SpinKitSpinningLines(
          color: color ?? Theme.of(context).primaryColor,
          size: spinKitSize,
        );
      },
    );

    return spinKit;
  }

  static Widget circularCachedImage({
    required String imageUrl,
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/no_image.png',
            height: height,
            width: width,
            fit: fit,
          );
        },
      ),
    );
  }

  static LinearProgressIndicator linearProgressIndicator =
      LinearProgressIndicator(
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
      );
}
