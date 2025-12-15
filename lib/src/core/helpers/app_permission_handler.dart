import 'dart:io';

import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:template_app/src/core/language/app_strings.dart';
import 'package:template_app/src/shared/shared_in_ui/app_dialogs/different_dialogs.dart';
import 'package:template_app/src/shared/shared_in_ui/project_widget/auto_direction_text.dart';
import 'package:template_app/src/shared/shared_in_ui/shared/ui_helpers.dart';

abstract class AppPermissionsHandler {
  //
  static Future<bool> notificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // return DifferentDialogs.showSnackBar(
      //   message: AppStrings.locationServicesNotEnabled.tr.capitalizeFirst,
      //   showIcon: true,
      //   success: false,
      //   info: true,
      //   buttonTitle: AppStrings.enable.tr.capitalizeFirst,
      //   onTabMainButton: () async => await openAppSettings(),
      // );
    } else {
      await Permission.notification.request();
    }
    return false;
  }

  // /// Checks permission for speech permission
  // static Future<bool> speechPermission() async {
  //   var status = await Permission.microphone.status;
  //   if (status.isGranted) {
  //     return true;
  //   } else if (status.isPermanentlyDenied) {
  //     // await openAppSettings();
  //   } else {
  //     await Permission.microphone.request();
  //   }
  //   return false;
  // }

  /// Checks permission for storage
  static Future<PermissionStatus> androidStorageStatus(
    bool checkingStatusOnly,
  ) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (checkingStatusOnly) {
      if (androidInfo.version.sdkInt <= 32) {
        return await Permission.storage.status;
      } else {
        return await Permission.photos.status;
      }
    } else {
      if (androidInfo.version.sdkInt <= 32) {
        return await Permission.storage.request();
      } else {
        return await Permission.photos.request();
      }
    }
  }

  static Future<bool?> storagePermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await androidStorageStatus(true);
    } else {
      status = await Permission.storage.status;
    }

    if (!status.isGranted || status.isDenied) {
      if (Platform.isAndroid) {
        status = await androidStorageStatus(false);
      } else {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await Get.dialog(
        RequestForDeniedPermissionDialog(
          title: AppStrings.storagePermission.tr.capitalizeFirst,
          explain: AppStrings.storagePermissionExplain.tr.capitalizeFirst,
        ),
      );
    }
    return false;
  }

  /// Check permission if speech is allowed or not
  // static Future<bool> isAllowedToRecord() async {
  //   var speech = await speechPermission();
  //   var storage = await storagePermission();
  //   return speech && storage!;
  // }
  static locationPermission() async {
    var status = await Permission.location.status;

    if (!status.isGranted || status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await DifferentDialogs.showSnackBar(
        message: AppStrings.locationServicesNotEnabled.tr.capitalizeFirst,
        showIcon: true,
        success: false,
        info: true,
        buttonTitle: AppStrings.enable.tr.capitalizeFirst,
        onTabMainButton: Geolocator.openLocationSettings,
      );
      //  await Get.dialog(
      //   RequestForDeniedPermissionDialog(
      //     title: AppStrings.titleLocationPermission.tr.capitalizeFirst,
      //     explain: AppStrings.locationPermissionExplain.tr.capitalizeFirst,
      //   ),
      // );
    }
    return false;
  }

  static calendarPermission() async {
    var status = await Permission.calendarWriteOnly.status;

    if (!status.isGranted || status.isDenied) {
      status = await Permission.calendarWriteOnly.request();
    }

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await Get.dialog(
        RequestForDeniedPermissionDialog(
          title: AppStrings.titleCalendarPermission.tr.capitalizeFirst,
          explain: AppStrings.calendarPermission.tr.capitalizeFirst,
        ),
      );
    }
    return false;
  }
}

class RequestForDeniedPermissionDialog extends StatelessWidget {
  final String? title;
  final String? explain;

  const RequestForDeniedPermissionDialog({
    super.key,
    required this.title,
    required this.explain,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // alignment: Alignment.center,
      title: AutoDirectionText(
        title!,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.zero,
      // insetPadding: EdgeInsets.all(32),
      titlePadding: const EdgeInsets.all(16.0),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoDirectionText(
            explain!,
            style: Get.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        UiHelper.verticalSpaceMedium,
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Get.back(result: false);
                },
                child: AutoDirectionText(
                  AppStrings.deny.tr.capitalizeFirst!,
                  style: Get.textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () async {
                  Get.close(1);
                  await openAppSettings();
                },
                child: AutoDirectionText(
                  AppStrings.settings.tr.capitalizeFirst!,
                  style: Get.textTheme.titleSmall!.copyWith(
                    // color: Colors.grey.shade400,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
