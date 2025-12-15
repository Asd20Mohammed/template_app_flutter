// Auto-size-text import removed
import '/src/shared/shared_in_ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../auto_direction_text.dart';

class SwitchFormBuilderWidget extends StatelessWidget {
  final String? text, keyName;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? fillColor;
  final double? borderRadius;
  final ValueChanged<bool?>? onChange;
  final bool? initialValue;
  final bool isRequired;

  const SwitchFormBuilderWidget({
    super.key,
    required this.text,
    this.keyName,
    this.fillColor,
    this.textColor,
    this.borderRadius,
    this.onChange,
    this.initialValue = false,
    this.isRequired = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: keyName!,
      validator: FormBuilderValidators.compose([
        if (isRequired) FormBuilderValidators.required(),
      ]),
      initialValue: initialValue ?? false,
      onChanged: onChange,
      builder: (FormFieldState<bool> field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            errorText: field.errorText,
            isDense: true,
            hintStyle: Get.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          child: Card(
            elevation: 0,
            color: fillColor,
            shape: SharedStyle.roundedRectangleBorderShape(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: SwitchListTile(
                value: field.value ?? initialValue ?? false,
                dense: true,
                onChanged: (newValue) => field.didChange(newValue),
                title: AutoDirectionText(
                  text!,
                  style:
                      textStyle ??
                      Get.textTheme.titleSmall!.copyWith(
                        color: Get.textTheme.bodySmall!.color,
                      ),
                ),
                activeThumbColor: Colors.green,
                inactiveTrackColor: Theme.of(
                  context,
                ).dividerColor.withValues(alpha: 0.2),
                inactiveThumbColor: Colors.grey.shade300,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
          ),
        );
      },
    );
  }
}
