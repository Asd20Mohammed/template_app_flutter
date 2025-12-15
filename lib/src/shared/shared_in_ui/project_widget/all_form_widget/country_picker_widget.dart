// Auto-size-text import removed
import '/src/core/language/app_strings.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:template_app/src/core/utils/responsive_size.dart';
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../shared/ui_helpers.dart';
import '../auto_direction_text.dart';

class CountryPickerWidget extends StatelessWidget {
  final Function? onTap;
  final bool isRequired;
  final String keyName;
  final String? labelText;
  final Function(Country?)? onChange;
  final Country? initialValue;
  final bool enableChangeCountry;

  // final String labelText;

  const CountryPickerWidget({
    super.key,
    this.onTap,
    this.isRequired = false,
    required this.keyName,
    this.labelText,
    this.initialValue,
    this.onChange,
    this.enableChangeCountry = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AutoDirectionText(
              labelText?.tr.capitalizeFirst ?? '',
              style: Get.textTheme.bodySmall!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isRequired)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  ' * ',
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        UiHelper.verticalSpaceSmall,
        FormBuilderField<Country>(
          name: keyName,
          initialValue: initialValue,
          onChanged: onChange,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
          builder: (FormFieldState<Country> field) {
            return InputDecorator(
              key: Key(field.value?.countryCode ?? 'AS'),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorText: field.errorText,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              child: Card(
                margin: EdgeInsets.zero,
                color: !enableChangeCountry
                    ? Theme.of(context).disabledColor.withValues(alpha: 0.1)
                    : null,
                elevation: 0,
                child: InkWell(
                  onTap: enableChangeCountry
                      ? () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            countryListTheme: CountryListThemeData(
                              textStyle: Get.textTheme.titleSmall,
                              inputDecoration: InputDecoration(
                                hintText:
                                    AppStrings.selectCounty.tr.capitalizeFirst,
                                helperStyle: Get.textTheme.titleSmall,
                                labelStyle: Get.textTheme.titleSmall,
                                fillColor: Theme.of(
                                  context,
                                ).inputDecorationTheme.fillColor,
                                // hintStyle: Get.textTheme.subtitle2,
                              ),
                            ),
                            onSelect: (Country country) {
                              field.didChange(country);
                            },
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: field.value?.countryCode != null
                              ? AutoDirectionText(
                                  generateFlagEmojiUnicode(
                                    field.value!.countryCode,
                                  ),
                                  style: Get.textTheme.titleSmall!.copyWith(
                                    color: !enableChangeCountry
                                        ? Theme.of(
                                            context,
                                          ).disabledColor.withValues(alpha: 0.5)
                                        : null,
                                  ),
                                )
                              : Icon(Icons.countertops, size: 24.sp),
                        ),
                        Expanded(
                          child: AutoDirectionText(
                            field.value?.name ??
                                AppStrings.selectCounty.tr.capitalizeFirst!,
                            style: Get.textTheme.titleSmall!.copyWith(
                              color: !enableChangeCountry
                                  ? Theme.of(
                                      context,
                                    ).disabledColor.withValues(alpha: 0.5)
                                  : null,
                            ),
                          ),
                        ),
                        if (enableChangeCountry)
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String generateFlagEmojiUnicode(String countryCode) {
    const base = 127397;
    return countryCode.codeUnits
        .map((e) => String.fromCharCode(base + e))
        .toList()
        .reduce((value, element) => value + element)
        .toString();
  }
}
