import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_utils/get_utils.dart';
import '../../shared/ui_helpers.dart';
import 'input_text_field_widget.dart';

class PasswordInput extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? confirmLabelText;
  final String? confirmHintText;
  final String keyName;
  final String? attributeKey2;
  final bool isSignUp;
  final int requiredMinLength;
  final bool isFill;

  // final EdgeInsetsGeometry contentPadding;
  // final double inputBorderRadius;

  // final Color fillColor;

  const PasswordInput({
    super.key,
    required this.hintText,
    this.labelText,
    required this.keyName,
    this.isSignUp = false,
    this.attributeKey2,
    this.requiredMinLength = 6,
    this.isFill = true,
    this.confirmLabelText,
    this.confirmHintText,
    // this.contentPadding, this.inputBorderRadius,
  });

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isHidden = true;
  String? firstPass;

  @override
  Widget build(BuildContext context) {
    if (widget.isSignUp) {
      return Column(
        children: <Widget>[
          buildTextFormField,
          UiHelper.verticalSpaceMedium,
          buildConfirmPassword,
        ],
      );
    } else {
      return buildTextFormField;
    }
  }

  Widget get buildTextFormField {
    return InputTextFieldWidget(
      keyName: widget.keyName,
      hintText: widget.hintText,
      labelText: widget.labelText,
      obscureText: isHidden,
      // contentPadding: widget.contentPadding,
      // inputBorderRadius: widget.inputBorderRadius,
      maxLines: 1,
      isRequired: true,
      isFill: widget.isFill,
      minLength: widget.requiredMinLength,
      textInputType: TextInputType.text,
      // borderSide: const BorderSide(),
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        onPressed: _toggleVisibility,
        icon: isHidden
            ? const Icon(Icons.visibility_off)
            : Icon(Icons.visibility, color: Theme.of(context).primaryColor),
      ),
      onChange: (pass1) {
        setState(() {
          firstPass = pass1;
        });
      },
    );
  }

  Widget get buildConfirmPassword {
    return InputTextFieldWidget(
      keyName: widget.attributeKey2 ?? '',
      labelText: widget.confirmLabelText,
      hintText: widget.confirmHintText,
      textInputType: TextInputType.text,
      obscureText: isHidden,
      maxLines: 1,
      minLength: widget.requiredMinLength,
      isRequired: true,
      prefixIcon: const Icon(Icons.lock_outlined),
      suffixIcon: IconButton(
        onPressed: _toggleVisibility,
        icon: isHidden
            ? const Icon(Icons.visibility_off_outlined)
            : const Icon(Icons.visibility_outlined),
      ),
      validator: firstPass != null && firstPass!.isNotEmpty
          ? FormBuilderValidators.equal(
              firstPass!,
              errorText: "passwordsDoNotMatch".tr.capitalizeFirst,
            )
          : null,
    );
  }

  void _toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
