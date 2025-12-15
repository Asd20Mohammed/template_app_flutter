// Auto-size-text import removed
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PhoneInputWidget extends StatelessWidget {
  final String? keyName;
  final String? labelText;
  final bool? isRequired;
  final bool isEnabled;
  final bool inProgressEditWidget;
  final bool startLoading;
  final Color? fillColor;
  final Function(PhoneNumber?)? onChange;

  // final Color labelTextColor;
  final String? hintText;
  final PhoneNumber? initialValue;
  final bool set1Subtitle;

  // final Function onChange;

  const PhoneInputWidget({
    super.key,
    required this.keyName,
    this.labelText,
    this.isRequired = true,
    this.isEnabled = true,
    this.fillColor,
    // this.labelTextColor,
    this.hintText,
    this.initialValue,
    this.startLoading = false,
    this.inProgressEditWidget = false,
    this.set1Subtitle = false,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHasLabel =
        (labelText != null && labelText!.isNotEmpty) ||
        (hintText != null && hintText!.isNotEmpty);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isHasLabel,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  text: labelText ?? hintText ?? '',
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    if (isRequired ?? false)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red, // Red star for required fields
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              UiHelper.verticalSpaceSmall,
            ],
          ),
        ),
        FormBuilderField<PhoneNumber>(
          name: keyName!,
          onChanged: onChange,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            if (isRequired!) FormBuilderValidators.required(),
          ]),
          initialValue: initialValue,
          builder: (FormFieldState<PhoneNumber> field) {
            return Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  titleMedium: TextStyle(
                    color: Theme.of(context).primaryColor,
                    // color: AppColors.primaryColor,
                  ),
                  titleSmall: TextStyle(color: Theme.of(context).primaryColor),
                  bodyLarge: TextStyle(color: Theme.of(context).primaryColor),
                  bodyMedium: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) async {
                    // bool isValid = await PhoneNumberUtil.isValidNumber(
                    //   isoCode: number.isoCode,
                    //   phoneNumber: number.phoneNumber,
                    // );
                    //
                    // if (field.mounted && isValid) {
                    //   field.didChange(number);
                    // }
                    if (field.value == number) return;
                    if (field.mounted) {
                      field.didChange(number);
                    }
                  },
                  initialValue:
                      // Prefer the form state value if available
                      field.value ?? initialValue,
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    useEmoji: true,
                    // trailingSpace: false,
                  ),
                  ignoreBlank: true,
                  autoFocus: false,
                  isEnabled: inProgressEditWidget ? isEnabled : true,
                  textStyle: Get.textTheme.titleSmall,
                  selectorTextStyle: Get.textTheme.titleSmall,
                  spaceBetweenSelectorAndTextField: 0.0,
                  selectorButtonOnErrorPadding: 16,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    // signed: true,
                    // decimal: false,
                  ),
                  searchBoxDecoration: const InputDecoration(
                    isDense: true,
                    filled: false,
                    // style
                  ),
                  locale: 'en',
                  inputDecoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    hintStyle: Get.textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    suffixIcon: Visibility(
                      visible: startLoading && inProgressEditWidget,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SpinKitFadingCircle(
                          size: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    fillColor:
                        fillColor ??
                        Theme.of(context).inputDecorationTheme.fillColor,
                    hintText: hintText ?? labelText,
                    errorText: field.errorText,
                    border: isEnabled && inProgressEditWidget
                        ? const UnderlineInputBorder()
                        : const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none,
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
}
