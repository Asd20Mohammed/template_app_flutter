// Auto-size-text import removed
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import '/src/core/language/app_strings.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../auto_direction_text.dart';

class ColorPickerWidget extends StatelessWidget {
  final String keyName;
  final Color? initialValue;
  final Function(Color?)? onChange;
  final bool isRequired;
  final String labelText;

  const ColorPickerWidget({
    super.key,
    required this.keyName,
    this.initialValue,
    this.onChange,
    this.isRequired = false,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: FormBuilderField<Color>(
        name: keyName,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        initialValue: initialValue ?? Theme.of(context).primaryColor,
        onChanged: onChange,
        builder: (FormFieldState<Color> field) {
          return InkWell(
            onTap: () {
              Get.defaultDialog(
                title: labelText,
                cancel: Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: TextButton(
                    child: AutoDirectionText(AppStrings.ok.tr.capitalizeFirst!),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                content: Card(
                  child: SingleChildScrollView(
                    child: ColorPicker(
                      color: initialValue ?? Theme.of(context).primaryColor,
                      onColorChanged: (Color color) {
                        field.didChange(color);
                      },
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.both: false,
                        ColorPickerType.primary: false,
                        ColorPickerType.accent: false,
                        ColorPickerType.bw: false,
                        ColorPickerType.custom: false,
                        ColorPickerType.wheel: true,
                      },
                      borderRadius: 22,
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AutoDirectionText(
                      labelText,
                      style: Get.textTheme.titleSmall,
                    ),
                  ),
                  ColorIndicator(
                    color: field.value!,
                    // HSVColor.fromColor(field.value),
                  ),
                  UiHelper.horizontalSpaceTiny,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
