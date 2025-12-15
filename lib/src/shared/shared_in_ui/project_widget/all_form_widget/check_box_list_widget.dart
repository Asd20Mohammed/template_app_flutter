// Auto-size-text import removed
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auto_direction_text.dart';

class CheckBoxListWidget extends StatelessWidget {
  final Function? onUpdate;
  final String? title;

  const CheckBoxListWidget({super.key, this.onUpdate, this.title});

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool?>(
      initialValue: false,
      builder: (value, updateFn) {
        return ListTile(
          title: AutoDirectionText(title!, style: Get.textTheme.titleSmall),
          trailing: Checkbox(
            onChanged: updateFn,
            value: value,
            activeColor: Colors.green,
          ),
          // subtitle:  AutoDirectionText(teamOrGroup.getID()),
        );
      },
      onUpdate: onUpdate as void Function(bool?),
    );
  }
}
