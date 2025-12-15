import 'dart:async';
// Auto-size-text import removed
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../auto_direction_text.dart';

class PinCodeFieldWidget extends StatefulWidget {
  final String keyName;
  final String? labelText;
  final bool isRequired;
  final bool isNumeric;
  final Color? fillColor;
  final int? length;
  final TextInputType keyboardInputType;
  final Function(String?)? onChange;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onCompleted;
  final StreamController<ErrorAnimationType>? errorController;

  const PinCodeFieldWidget({
    super.key,
    required this.keyName,
    this.errorController,
    this.labelText,
    this.isRequired = true,
    this.isNumeric = false,
    this.fillColor,
    this.onChange,
    this.length,
    this.keyboardInputType = TextInputType.number,
    this.validator,
    this.onCompleted,
  });

  @override
  State<PinCodeFieldWidget> createState() => _PinCodeFieldWidgetState();
}

class _PinCodeFieldWidgetState extends State<PinCodeFieldWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.keyName,
      onChanged: widget.onChange,
      validator: FormBuilderValidators.compose([
        if (widget.isRequired) FormBuilderValidators.required(),
        if (widget.isNumeric) FormBuilderValidators.numeric(),
      ]),
      onReset: () {
        _textEditingController.clear();
      },
      // initialValue: initialValue,
      builder: (FormFieldState<String> field) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: PinCodeTextField(
            appContext: context,
            controller: _textEditingController,
            enableActiveFill: true,
            obscureText: false,
            enablePinAutofill: true,
            length: widget.length ?? 6,
            keyboardType: widget.keyboardInputType,
            onCompleted: widget.onCompleted,
            validator: widget.isNumeric
                ? FormBuilderValidators.numeric()
                : widget.validator,
            blinkWhenObscuring: true,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            autovalidateMode: AutovalidateMode.always,
            readOnly: false,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 50,
              fieldWidth: 50,
              borderWidth: 1,

              ///.. before enter value (init)
              //box fill color
              inactiveFillColor: Theme.of(
                context,
              ).inputDecorationTheme.fillColor,
              // box borderColor
              inactiveColor: Theme.of(context).inputDecorationTheme.fillColor,

              ///...current selected
              //box fill color
              selectedFillColor: Theme.of(
                context,
              ).inputDecorationTheme.fillColor,
              // box borderColor
              selectedColor: Colors.green,

              ///...after enter value
              // box border color
              activeColor: Theme.of(context).primaryColor,
              //box fill color
              activeFillColor: Theme.of(context).inputDecorationTheme.fillColor,

              ///... disable color
              // disabledColor: Colors.grey,

              ///... on error
              errorBorderColor: Theme.of(context).colorScheme.error,
            ),
            autoFocus: true,
            // backgroundColor: fillColor??Theme.of(context).inputDecorationTheme.fillColor,
            autoDisposeControllers: true,
            errorAnimationController: widget.errorController,
            beforeTextPaste: (String? paste) {
              if (paste?.contains('please join us on room with current info') ??
                  false) {
                var pattern = RegExp(r'(\d+)');
                paste?.split(pattern);
              }
              return true;
            },
            onChanged: (value) {
              widget.onChange?.call(value);
              field.didChange(value);
            },
            animationType: AnimationType.fade,
            animationDuration: const Duration(microseconds: 300),
          ),
        );
      },
    );
  }
}

class CheckBoxFieldWidget extends StatelessWidget {
  final bool initialValue;
  final bool isRequired;
  final String? title;
  final String keyName;
  final Function(bool?)? onChange;

  const CheckBoxFieldWidget({
    super.key,
    this.initialValue = false,
    required this.title,
    required this.keyName,
    this.onChange,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: keyName,
      onChanged: onChange,
      validator: FormBuilderValidators.compose([
        if (isRequired) FormBuilderValidators.required(),
      ]),
      initialValue: initialValue,
      builder: (FormFieldState<bool> field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            errorText: field.errorText,
            contentPadding: EdgeInsets.zero,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          child: CheckboxListTile(
            value: field.value,
            activeColor: Theme.of(context).primaryColor,
            // contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              field.didChange(value);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            tileColor: Theme.of(context).inputDecorationTheme.fillColor,

            title: AutoDirectionText(
              title ?? 'no title',
              style: Get.textTheme.titleSmall,
            ),
          ),
        );
      },
    );
  }
}
