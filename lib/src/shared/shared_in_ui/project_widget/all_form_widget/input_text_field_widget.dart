import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../shared/ui_helpers.dart';

class InputTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? keyName;
  final TextInputType? textInputType;
  final bool isNumeric;
  final bool isUrl;
  final bool enabled;
  final bool isEmail;
  final bool? isRequired;
  final FocusNode? focusNode;

  // final bool isDomain;
  final bool isFill;
  final Function(String?)? onChange;
  final InputBorder? inputBorder;
  final int? maxLength;
  final int? minLine;
  final int? minLength;
  final int? maxLines;
  final bool autoFocus;
  final bool isHasLabel;
  final bool obscureText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final bool? isAddMessage;
  final VoidCallback? onEditingComplete;

  const InputTextFieldWidget({
    super.key,
    this.focusNode,
    this.onEditingComplete,
    this.hintText,
    this.labelText,
    this.helperText,
    this.enabled = true,
    required this.keyName,
    this.textInputType,
    this.initialValue = '',
    this.isEmail = false,
    this.isNumeric = false,
    this.isRequired = true,
    this.isUrl = false,
    // this.isDomain = false,
    this.isFill = true,
    // this.fillColor,
    this.minLine,
    this.autoFocus = false,
    this.prefixIcon,
    this.style,
    this.onChange,
    this.inputBorder,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
    this.maxLines,
    this.fillColor,
    this.obscureText = false,
    this.minLength,
    this.validator,
    this.controller,
    this.isAddMessage = false,
    this.isHasLabel = true,
  });

  @override
  _InputTextFieldWidgetState createState() => _InputTextFieldWidgetState();
}

class _InputTextFieldWidgetState extends State<InputTextFieldWidget> {
  String? text;
  bool isRTL = false;

  @override
  void initState() {
    super.initState();
    text = widget.hintText ?? widget.labelText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.isHasLabel,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  text: widget.labelText ?? widget.hintText ?? '',
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    if (widget.isRequired ?? false)
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
        AutoDirection(
          text: text ?? '',
          onDirectionChange: (bool change) {},
          child: widget.isAddMessage!
              ? FormBuilderTextField(
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  name: widget.keyName!,
                  style: widget.style ?? Get.textTheme.titleSmall,
                  minLines: widget.minLine,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  autofocus: widget.autoFocus,
                  onEditingComplete: widget.onEditingComplete,
                  autofillHints: [
                    if (widget.isEmail) AutofillHints.email,
                    if (widget.isNumeric) AutofillHints.telephoneNumber,
                    if (widget.isUrl) AutofillHints.url,
                  ],
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: Get.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    alignLabelWithHint: true,
                    // fillColor: widget.fillColor,
                    filled: widget.isFill,
                    suffixIcon: widget.suffixIcon,
                    prefixIcon: widget.prefixIcon,
                    prefixIconColor: Theme.of(context).hintColor,
                    suffixIconColor: Theme.of(context).hintColor,
                    iconColor: Theme.of(context).primaryColor,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(20.0),
                    focusedBorder: widget.inputBorder,
                    border:
                        widget.inputBorder ??
                        const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide.none,
                        ),
                    helperText: widget.helperText,
                    helperStyle: Get.textTheme.bodySmall!.copyWith(height: 1.1),
                  ),
                  onReset: () {
                    setState(() {
                      text = widget.labelText ?? widget.hintText ?? '';
                    });
                  },
                  enableSuggestions: true,
                  contextMenuBuilder: (context, editableTextState) {
                    // final TextEditingValue value = editableTextState.textEditingValue;
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;

                    /// TODO Share , Undo and Redo
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  validator: FormBuilderValidators.compose([
                    if (widget.isRequired ?? false)
                      FormBuilderValidators.required(),
                    if (widget.isEmail) FormBuilderValidators.email(),
                    if (widget.isNumeric) FormBuilderValidators.numeric(),
                    if (widget.isUrl) FormBuilderValidators.url(),
                    if (widget.minLength != null)
                      FormBuilderValidators.minLength(widget.minLength!),
                    if (widget.validator != null) widget.validator!,
                    // if (widget.isDomain ?? false) domainValidation
                  ]),
                  keyboardType: getKeyboardType(),
                  inputFormatters:
                      widget.inputFormatters ?? getEmailInputFormatter(),
                  onChanged: (str) {
                    if (!mounted) return;
                    setState(() {
                      text = str;
                    });
                    if (widget.onChange != null) {
                      widget.onChange!.call(str);
                    }
                  },
                )
              : FormBuilderTextField(
                  focusNode: widget.focusNode,
                  initialValue: widget.initialValue,
                  name: widget.keyName!,
                  style: widget.style ?? Get.textTheme.titleSmall,
                  minLines: widget.minLine,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  autofocus: widget.autoFocus,
                  onEditingComplete: widget.onEditingComplete,
                  autofillHints: [
                    if (widget.isEmail) AutofillHints.email,
                    if (widget.isNumeric) AutofillHints.telephoneNumber,
                    if (widget.isUrl) AutofillHints.url,
                  ],
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: Get.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    alignLabelWithHint: true,
                    fillColor: widget.fillColor,
                    filled: widget.isFill,
                    suffixIcon: widget.suffixIcon,
                    prefixIcon: widget.prefixIcon,
                    prefixIconColor: Theme.of(context).hintColor,
                    suffixIconColor: Theme.of(context).hintColor,
                    iconColor: Theme.of(context).primaryColor,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(20.0),
                    focusedBorder: widget.inputBorder,
                    border:
                        widget.inputBorder ??
                        const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide.none,
                        ),
                    helperText: widget.helperText,
                    helperStyle: Get.textTheme.bodySmall!.copyWith(height: 1.1),
                  ),
                  onReset: () {
                    setState(() {
                      text = widget.labelText ?? widget.hintText ?? '';
                    });
                  },
                  enableSuggestions: true,
                  contextMenuBuilder: (context, editableTextState) {
                    // final TextEditingValue value = editableTextState.textEditingValue;
                    final List<ContextMenuButtonItem> buttonItems =
                        editableTextState.contextMenuButtonItems;

                    /// TODO Share , Undo and Redo , Cut , Copy , Paste , translate
                    return AdaptiveTextSelectionToolbar.buttonItems(
                      anchors: editableTextState.contextMenuAnchors,
                      buttonItems: buttonItems,
                    );
                  },
                  validator: FormBuilderValidators.compose([
                    if (widget.isRequired ?? false)
                      FormBuilderValidators.required(),
                    if (widget.isEmail) FormBuilderValidators.email(),
                    if (widget.isNumeric) FormBuilderValidators.numeric(),
                    if (widget.isUrl) FormBuilderValidators.url(),
                    if (widget.minLength != null)
                      FormBuilderValidators.minLength(widget.minLength!),
                    if (widget.validator != null) widget.validator!,
                    // if (widget.isDomain ?? false) domainValidation
                  ]),
                  keyboardType: getKeyboardType(),
                  inputFormatters:
                      widget.inputFormatters ?? getEmailInputFormatter(),
                  onChanged: (str) {
                    if (!mounted) return;
                    setState(() {
                      text = str;
                    });
                    if (widget.onChange != null) {
                      widget.onChange!.call(str);
                    }
                  },
                ),
        ),
      ],
    );
  }

  TextInputType? getKeyboardType() {
    if (widget.textInputType != null) {
      return widget.textInputType;
    } else {
      return (widget.minLine != null && widget.minLine! >= 7)
          ? TextInputType.multiline
          : TextInputType.text;
    }
  }

  List<TextInputFormatter>? getEmailInputFormatter() {
    return widget.isEmail
        ? [FilteringTextInputFormatter.deny(RegExp('[ ]'))]
        : null;
  }
}
