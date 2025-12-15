// Auto-size-text import removed
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../auto_direction_text.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';

class SliderWidget extends StatelessWidget {
  final String keyName;
  final String name;
  final double? initialValue;
  final bool isRequired;
  const SliderWidget({
    super.key,
    required this.name,
    this.initialValue = 0.0,
    required this.keyName,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoDirectionText(
          name,
          style: Get.textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        UiHelper.verticalSpaceTiny,
        FormBuilderSlider(
          name: keyName,
          initialValue: initialValue!,
          min: 0.0,
          max: 100.0,
          divisions: 100,
          onChanged: (value) {
            if (kDebugMode) {
              print(value);
            }
          },
        ),
      ],
    );
  }
}
