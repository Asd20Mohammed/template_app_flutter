import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpersMethods {
  HelpersMethods._();

  static void showSnackBar({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      '',
      message,
      backgroundColor: backgroundColor ?? Colors.black87,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showErrorSnackBar(String message) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }

  static void showSuccessSnackBar(String message) {
    showSnackBar(message: message, backgroundColor: Colors.green);
  }

  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }
}
