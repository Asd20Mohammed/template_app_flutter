import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '/src/core/language/app_strings.dart';
import '../auto_direction_text.dart';

class GenericDropDownMenu<T> extends StatelessWidget {
  final List<T> list;
  final String? kfHeaderTitle;
  final String keyName;
  final String? labelText;
  final String? hintText;
  final Function(T?)? onChange;
  final T? initialValue;
  final bool isRequired;
  final bool showNoneItem;
  final Color? color;
  final String Function(T)? itemToString; // لتحويل الكائن إلى نص

  const GenericDropDownMenu({
    super.key,
    required this.list,
    this.kfHeaderTitle,
    required this.keyName,
    this.labelText,
    this.hintText,
    this.onChange,
    this.initialValue,
    this.isRequired = false,
    this.showNoneItem = true,
    this.color,
    required this.itemToString,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              AutoDirectionText(
                labelText ?? '',
                style: Get.textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isRequired)
                AutoDirectionText(
                  '  (${AppStrings.optional.tr.capitalizeFirst} )',
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
            ],
          ),
        UiHelper.verticalSpaceSmall,
        FormBuilderDropdown<T>(
          name: keyName,
          onChanged: onChange,
          initialValue: initialValue,
          isExpanded: true,
          isDense: true,
          menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
          menuWidth: MediaQuery.of(context).size.width * 0.9,
          style: Get.textTheme.bodyMedium,
          dropdownColor:
              color ?? Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(10.0),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            filled: true,
            fillColor:
                color ?? Theme.of(context).inputDecorationTheme.fillColor,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
          items: [
            if (showNoneItem)
              DropdownMenuItem(
                value: null,
                child: AutoDirectionText(AppStrings.none.tr.capitalizeFirst!),
              ),
            for (var item in list)
              DropdownMenuItem(
                value: item,
                child: AutoDirectionText(itemToString!(item)),
              ),
          ],
        ),
      ],
    );
  }
}
