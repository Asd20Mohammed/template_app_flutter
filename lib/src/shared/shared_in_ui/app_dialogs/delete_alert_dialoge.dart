import '../../../core/language/app_strings.dart';
import '../../../core/themes/theme_helper.dart';
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../project_widget/auto_direction_text.dart';

typedef FutureCallback = Future Function();

class AlertDialogWidget extends StatefulWidget {
  final FutureCallback onDeletePress;
  final String? alertText;
  final String? cancelText;
  final String? confirmText;
  final Widget? alertTextWidget;
  final bool showIconInColumn;

  const AlertDialogWidget({
    super.key,
    required this.onDeletePress,
    this.alertText,
    this.confirmText,
    this.alertTextWidget,
    this.showIconInColumn = false,
    this.cancelText,
  });

  @override
  _AlertDialogWidgetState createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  bool _startDelete = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // actionsOverflowDirection: VerticalDirection.up,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      buttonPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      contentPadding: const EdgeInsets.only(
        top: 16.0,
        bottom: 12.0,
        left: 8.0,
        right: 8.0,
      ),
      actions: _startDelete
          ? null
          : [
              TextButton(
                onPressed: () {
                  hideDialog(result: null);
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: AutoDirectionText(
                  widget.cancelText ?? AppStrings.cancel.tr.capitalizeFirst!,
                  style: Get.textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _startDelete = true;
                  });
                  var result = await widget.onDeletePress.call();
                  hideDialog(result: result);
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: AutoDirectionText(
                  widget.confirmText ?? AppStrings.delete.tr.capitalizeFirst!,
                  style: Get.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showIconInColumn && _startDelete)
              Icon(Icons.info, size: 40, color: ThemeHelper.contrastColor),
            Visibility(
              visible: _startDelete,
              replacement: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.showIconInColumn) ...[
                    Icon(Icons.info, size: 40, color: ThemeHelper.contrastColor),
                    UiHelper.horizontalSpaceSmall,
                  ],
                  Expanded(
                    child:
                        widget.alertTextWidget ??
                        AutoDirectionText(
                          widget.alertText ??
                              'areYouSureToDelete'.tr.capitalizeFirst!,
                          style: Get.textTheme.titleMedium!.copyWith(),
                        ),
                  ),
                ],
              ),
              child: buildProgress(),
            ),
          ],
        ),
      ),
    );
  }

  void hideDialog({dynamic result}) {
    if (Get.isDialogOpen!) {
      Get.back(result: result);
      // Get.back();
    }
  }

  Widget buildProgress() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: AutoDirectionText(
              AppStrings.pleaseWaite.tr.capitalizeFirst!,
              style: Get.textTheme.titleMedium,
            ),
          ),
          UiHelper.horizontalSpaceMedium,
          SpinKitDualRing(
            color: Theme.of(context).primaryColor,
            size: 40,
            lineWidth: 4,
          ),
        ],
      ),
    );
  }
}
