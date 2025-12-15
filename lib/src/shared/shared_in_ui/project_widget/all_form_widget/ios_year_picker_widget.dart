import '/src/core/language/app_strings.dart';
import '/src/shared/shared_in_ui/project_widget/auto_direction_text.dart';
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class IOSYearPickerWidget extends StatefulWidget {
  final String keyName;
  final String? labelText;
  final int? initialValue;
  final bool isRequired;
  final ValueChanged<int?>? onChanged;
  final String? Function(String?)? validator;

  const IOSYearPickerWidget({
    super.key,
    required this.keyName,
    this.labelText,
    this.initialValue,
    this.isRequired = false,
    this.onChanged,
    this.validator,
  });

  @override
  State<IOSYearPickerWidget> createState() => _IOSYearPickerWidgetState();
}

class _IOSYearPickerWidgetState extends State<IOSYearPickerWidget> {
  late int selectedYear;
  late List<int> years;
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _generateYears();
    _initializeSelectedYear();
    _initializeScrollController();
  }

  void _generateYears() {
    final currentYear = DateTime.now().year;
    years = List.generate(100, (index) => currentYear - 4 - index);
  }

  void _initializeSelectedYear() {
    if (widget.initialValue != null && years.contains(widget.initialValue)) {
      selectedYear = widget.initialValue!;
    } else {
      selectedYear = years.first;
    }
  }

  void _initializeScrollController() {
    final initialIndex = years.indexOf(selectedYear);
    scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _showPicker() {
    showCupertinoModalPopup<int>(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Header with Done button
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(
                      AppStrings.cancel.tr.capitalizeFirst ?? 'Cancel',
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text(AppStrings.done.tr.capitalizeFirst ?? 'Done'),
                    onPressed: () {
                      widget.onChanged?.call(selectedYear);
                      Navigator.of(context).pop(selectedYear);
                    },
                  ),
                ],
              ),
            ),
            // Year picker
            Expanded(
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  selectedYear = years[index];
                },
                children: years.map((year) {
                  return Center(
                    child: Text(
                      year.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Row(
            children: [
              AutoDirectionText(
                widget.labelText!,
                style: Get.textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              widget.isRequired
                  ? AutoDirectionText(
                      '  *',
                      style: TextStyle(
                        color: Colors.red, // Red star for required fields
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : AutoDirectionText(
                      '  ( ${AppStrings.optional.tr.capitalizeFirst} )',
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
            ],
          ),
        UiHelper.verticalSpaceSmall,
        FormBuilderField<String>(
          name: widget.keyName,
          initialValue: widget.initialValue?.toString(),
          validator:
              widget.validator ??
              (widget.isRequired
                  ? FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      (value) {
                        if (value != null && value.isNotEmpty) {
                          final currentYear = DateTime.now().year;
                          final birthYear = int.tryParse(value);
                          if (birthYear == null ||
                              !(birthYear >= currentYear - 100 &&
                                  birthYear <= currentYear - 4)) {
                            return AppStrings
                                .validatorBirthYear
                                .tr
                                .capitalizeFirst;
                          }
                        }
                        return null;
                      },
                    ])
                  : null),
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showPicker,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: field.hasError
                          ? Border.all(
                              color: Theme.of(context).colorScheme.error,
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoDirectionText(
                          field.value?.toString() ??
                              AppStrings.selectYear.tr.capitalizeFirst ??
                              'Select Year',
                          style: TextStyle(
                            fontSize: 16,
                            color: field.value != null
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
