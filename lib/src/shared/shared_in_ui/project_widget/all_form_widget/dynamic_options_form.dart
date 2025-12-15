// Auto-size-text import removed
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../shared/ui_helpers.dart';
import '../auto_direction_text.dart';

class DynamicOptionsForm extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? keyName;
  final bool isEmail;
  final bool? isRequired;
  final bool isFill;
  final InputBorder? inputBorder;
  final int maxLength;
  final int? minLine;
  final int minLength;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final List<String>? initialOptions;
  const DynamicOptionsForm({
    super.key,
    this.hintText = 'Option',
    this.labelText,
    this.helperText,
    required this.keyName,
    this.initialValue = '',
    this.isEmail = false,
    this.isRequired = false,
    this.isFill = true,
    this.minLine,
    this.prefixIcon,
    this.inputBorder,
    this.suffixIcon,
    this.maxLength = 5,
    this.fillColor,
    required this.minLength,
    this.initialOptions,
  });
  @override
  _DynamicOptionsFormState createState() => _DynamicOptionsFormState();
}

class _DynamicOptionsFormState extends State<DynamicOptionsForm> {
  late List<TextEditingController> _controllers;
  late List<GlobalKey<FormBuilderFieldState>> _fieldKeys;

  @override
  void initState() {
    super.initState();
    final init =
        widget.initialOptions?.where((e) => e.trim().isNotEmpty).toList() ?? [];
    final cappedLen = init.isNotEmpty
        ? (init.length > widget.maxLength ? widget.maxLength : init.length)
        : widget.minLength;
    final count = cappedLen < widget.minLength ? widget.minLength : cappedLen;

    _controllers = List.generate(count, (index) {
      final c = TextEditingController();
      if (index < init.length) c.text = init[index];
      return c;
    });
    // add an empty trailing controller if we have room for adding more
    if (init.isNotEmpty && _controllers.length < widget.maxLength) {
      _controllers.add(TextEditingController());
    }

    _fieldKeys = List.generate(
      _controllers.length,
      (index) => GlobalKey<FormBuilderFieldState>(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> updatePosition(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final tempController = _controllers.removeAt(oldIndex);
      _controllers.insert(newIndex, tempController);

      final tempKey = _fieldKeys.removeAt(oldIndex);
      _fieldKeys.insert(newIndex, tempKey);
    });
  }

  void _updateFields(int index, String value) {
    if (index == _controllers.length - 1 &&
        value.isNotEmpty &&
        _controllers.length < widget.maxLength) {
      setState(() {
        _controllers.add(TextEditingController());
        _fieldKeys.add(GlobalKey<FormBuilderFieldState>());
      });
    } else if (value.isEmpty &&
        _controllers.length > 2 &&
        index != _controllers.length - 1) {
      setState(() {
        _controllers.removeAt(index);
        _fieldKeys.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.labelText != null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoDirectionText(
                widget.labelText ?? 'none',
                style: Get.textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              UiHelper.verticalSpaceSmall,
            ],
          ),
        ),
        ReorderableListView.builder(
          key: UniqueKey(),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            updatePosition(oldIndex, newIndex);
          },
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            return Column(
              key: ValueKey(index),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        key: _fieldKeys[index],
                        name: "${widget.keyName} ${index + 1}",
                        controller: _controllers[index],
                        validator: FormBuilderValidators.compose([
                          if (widget.isRequired ?? false)
                            FormBuilderValidators.required(),
                        ]),
                        onChanged: (value) => _updateFields(index, value!),
                        contextMenuBuilder: (context, editableTextState) {
                          final List<ContextMenuButtonItem> buttonItems =
                              editableTextState.contextMenuButtonItems;
                          return AdaptiveTextSelectionToolbar.buttonItems(
                            anchors: editableTextState.contextMenuAnchors,
                            buttonItems: buttonItems,
                          );
                        },
                        enableSuggestions: true,
                        decoration: InputDecoration(
                          hintText: "${widget.hintText} ${index + 1}",
                          alignLabelWithHint: true,
                          fillColor: widget.fillColor,
                          hintStyle: Get.textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                borderSide: BorderSide.none,
                              ),
                          helperText: widget.helperText,
                          helperStyle: Get.textTheme.bodySmall!.copyWith(
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.drag_indicator),
                  ],
                ),
                UiHelper.verticalSpaceSmall,
              ],
            );
          },
        ),
      ],
    );
  }
}
