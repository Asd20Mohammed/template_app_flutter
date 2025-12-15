import 'package:flutter/material.dart';

extension ResponsiveSize on num {
  double get w => toDouble();
  double get h => toDouble();
  double get sp => toDouble();
  double get r => toDouble();
}

class ScreenUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double setWidth(double width) => width;
  static double setHeight(double height) => height;
  static double setSp(double fontSize) => fontSize;
}
