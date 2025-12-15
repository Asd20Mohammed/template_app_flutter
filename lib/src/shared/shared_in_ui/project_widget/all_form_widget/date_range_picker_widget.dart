// Auto-size-text import removed
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../auto_direction_text.dart';

class DateRangeTimePickerWidget extends StatelessWidget {
  final String? keyName, labelText, hintText;
  final bool isFill;
  final Color? fillColor;
  final bool isRequired;
  final InputType inputType;
  final DateFormat? dateFormat;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTimeRange? initialValue;
  final InputBorder? inputBorder;
  final void Function(DateTimeRange?)? onChange;

  const DateRangeTimePickerWidget({
    super.key,
    this.keyName,
    this.labelText,
    this.hintText,
    this.isFill = true,
    this.fillColor,
    this.isRequired = true,
    this.inputType = InputType.date,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.initialValue,
    this.inputBorder,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoDirectionText(
          labelText!,
          style: Get.textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        UiHelper.verticalSpaceTiny,
        FormBuilderDateRangePicker(
          name: keyName!,
          initialValue: initialValue,
          style: Get.textTheme.titleMedium,
          firstDate: firstDate as DateTime,
          allowClear: true,
          currentDate: firstDate,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          lastDate: lastDate ?? DateTime.now(),
          onChanged: onChange,
          cursorColor: Theme.of(context).primaryColor,
          format: dateFormat ?? DateFormat('mm/dd/yyyy'),
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
          locale: Get.locale as Locale,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(12.0),
            filled: isFill,
            fillColor: fillColor,
            suffixIcon: Icon(
              Icons.calendar_month,
              color: Theme.of(context).primaryColor,
              size: Get.size.width * 0.05,
            ),
            hintText: hintText,
            border:
                inputBorder ??
                const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide.none,
                ),
          ),
        ),
      ],
    );
  }
}
