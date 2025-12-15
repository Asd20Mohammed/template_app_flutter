import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auto_direction_text.dart';

class LogoIcon extends StatelessWidget {
  final String? screenName;
  final String? tag;
  final String? path;

  const LogoIcon({super.key, this.screenName, this.tag, this.path});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag!,
      transitionOnUserGestures: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SvgPicture.asset(
              path!,
              width: 54,
              height: 54,
              // color: Theme.of(context).iconTheme.color,
            ),
          ),
          UiHelper.verticalSpaceMedium,
          screenName != null
              ? Flexible(
                  child: AutoDirectionText(
                    screenName!,
                    textAlign: TextAlign.center,

                    maxLines: 2,
                    style: Get.textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(),
          UiHelper.verticalSpaceLarge,
        ],
      ),
    );
  }
}
