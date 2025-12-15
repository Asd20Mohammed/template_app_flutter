import '/src/core/language/app_language.dart';
import '/src/core/language/app_strings.dart';
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../project_widget/auto_direction_text.dart';
import 'delete_alert_dialoge.dart';
import '/src/core/themes/app_colors.dart';
import '/src/core/themes/theme_helper.dart';
import '/src/shared/shared_in_ui/shared/shared_styles.dart';

class DifferentDialogs {
  DifferentDialogs._();

  static bool _isShowing = false;
  static bool _canPop = false;

  static showProgressDialog({
    String? msg,
    bool isDismissible = false,
    Widget? progressIcon,
  }) async {
    _isShowing = true;

    Get.dialog(
      PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: (didPop, _) {},
        child: AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 24.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AutoDirectionText(
                      msg ?? AppStrings.pleaseWaite.tr.capitalizeFirst!,
                      style: Get.textTheme.titleMedium!.copyWith(),
                    ),
                  ),
                  UiHelper.horizontalSpaceMedium,
                  Builder(
                    builder: (context) {
                      return progressIcon ??
                          SpinKitDualRing(
                            color: Theme.of(context).primaryColor,
                            size: 30,
                            lineWidth: 4,
                          );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: isDismissible,
    );
  }

  static hideProgressDialog() async {
    if (_isShowing && Get.isDialogOpen!) {
      _canPop = true;
      Get.close(1);
    }
    _isShowing = false;
  }

  static bool snackBarIsOpen = false;

  static showSnackBar({
    String? message,
    String? buttonTitle,
    Function? onTabMainButton,
    bool success = false,
    bool info = false,
    bool showIcon = false,
    SnackPosition? snackPosition,
  }) {
    // if (Get.isSnackbarOpen) {
    //   Get.close(1);
    // }

    if (snackBarIsOpen) {
      Get.close(1);
    }

    Widget? icon;
    if (showIcon && success) {
      icon = const Icon(Icons.check_circle, color: Colors.green);
    }

    if (showIcon && !success) {
      icon = const Icon(Icons.cancel, color: Colors.red);
    }
    if (showIcon && info) {
      icon = const Icon(Icons.info, color: Colors.yellow);
    }

    GetSnackBar(
      message: message,
      isDismissible: true,
      icon: icon,
      snackPosition: snackPosition ?? SnackPosition.TOP,
      borderRadius: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      duration: const Duration(seconds: 5),
      snackStyle: SnackStyle.FLOATING,
      shouldIconPulse: true,
      snackbarStatus: (SnackbarStatus? status) {
        snackBarIsOpen = status == SnackbarStatus.OPEN;
      },
      dismissDirection: DismissDirection.horizontal,
      mainButton: buttonTitle != null && onTabMainButton != null
          ? TextButton(
              onPressed: () {
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                onTabMainButton.call();
              },
              child: AutoDirectionText(
                buttonTitle,
                style: Get.textTheme.titleMedium!.copyWith(color: Colors.white),
              ),
            )
          : null,
    ).show();
  }

  static showRoomSelectionDialog({
    required List<dynamic> rooms,
    required Function(List<String>) onDelete,
    required String alertText,
  }) {
    Get.dialog(
      PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {},
        child: AlertDialog(
          title: AutoDirectionText(alertText, style: Get.textTheme.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: rooms
                .map(
                  (e) => ListTile(
                    title: AutoDirectionText(e.name!),
                    onTap: () {
                      onDelete([e.id!]);
                      Get.back();
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  static showDeleteAlertDialog({
    required FutureCallback onDelete,
    String? alertText,
    String? confirmText,
    String? cancelText,
    Widget? alertTextWidget,
    bool showIconInColumn = false,
  }) {
    return Get.dialog(
      PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {},
        child: AlertDialogWidget(
          onDeletePress: onDelete,
          alertText: alertText,
          confirmText: confirmText,
          showIconInColumn: showIconInColumn,
          alertTextWidget: alertTextWidget,
          cancelText: cancelText,
        ),
      ),
      barrierDismissible: true,
    );
  }

  static changeLangDialog() {
    final langController = Get.find<AppLanguageController>();

    Get.dialog(
      Dialog(
        shape: SharedStyle.roundedRectangleBorderShape(radius: 15),
        child: Builder(
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              constraints: BoxConstraints(
                minWidth: Get.width * 0.7,
                maxWidth: Get.width * 0.85,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoDirectionText(
                    AppStrings.changeLanguage.tr.capitalizeFirst!,
                    style: Get.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  UiHelper.verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.back();

                          langController.changeLanguage(const Locale('ar'));
                        },
                        shape: SharedStyle.roundedRectangleBorderShape(
                          radius: 10,
                        ),
                        color: ThemeHelper.adaptiveColor(
                          lightColor: AppColors.accentColor,
                          darkColor: AppColors.darkAccentColor,
                        ),
                        minWidth: Get.width * 0.3,
                        child: AutoDirectionText(
                          'العربية',
                          style: Get.textTheme.titleMedium!.copyWith(
                            color: ThemeHelper.contrastColor,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                          langController.changeLanguage(const Locale('en'));
                        },
                        shape: SharedStyle.roundedRectangleBorderShape(
                          radius: 10,
                        ),
                        color: ThemeHelper.adaptiveColor(
                          lightColor: AppColors.accentColor,
                          darkColor: AppColors.darkAccentColor,
                        ),
                        minWidth: Get.width * 0.3,
                        child: AutoDirectionText(
                          'English',
                          style: Get.textTheme.titleMedium!.copyWith(
                            color: ThemeHelper.contrastColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierColor: ThemeHelper.darkOverlayColor,
    );
  }

  static singOutAlertDialog({
    String? dialogTitle,
    String? alertText,
    String? okButtonText,
    String? cancelButtonTex,
    required Function onOkButtonClicked,
  }) {
    Get.dialog(
      Dialog(
        shape: SharedStyle.roundedRectangleBorderShape(radius: 15),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          constraints: BoxConstraints(
            minWidth: Get.width * 0.7,
            maxWidth: Get.width * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoDirectionText(
                AppStrings.signOut.tr.capitalizeFirst!,
                style: Get.textTheme.titleLarge!.copyWith(),
              ),
              UiHelper.verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    elevation: 0,
                    shape: SharedStyle.roundedRectangleBorderShape(radius: 5),
                    onPressed: () => Get.back(),
                    minWidth: Get.width * 0.3,
                    child: AutoDirectionText(
                      AppStrings.cancel.tr.capitalizeFirst!,
                      style: Get.textTheme.titleMedium!,
                    ),
                  ),
                  MaterialButton(
                    elevation: 0,
                    shape: SharedStyle.roundedRectangleBorderShape(radius: 5),
                    onPressed: () => onOkButtonClicked(),
                    color: ThemeHelper.adaptiveColor(
                      lightColor: AppColors.accentColor,
                      darkColor: AppColors.darkAccentColor,
                    ),
                    minWidth: Get.width * 0.3,
                    child: AutoDirectionText(
                      AppStrings.yes.tr.capitalizeFirst!,
                      style: Get.textTheme.titleMedium!.copyWith(
                        color: ThemeHelper.contrastColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: ThemeHelper.darkOverlayColor,
      barrierDismissible: false,
    );
  }
}
