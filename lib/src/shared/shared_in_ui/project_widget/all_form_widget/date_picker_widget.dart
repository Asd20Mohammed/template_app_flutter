import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import '../../shared/ui_helpers.dart';

/// Professional DateTime Picker Widget with enhanced features
class DateTimePickerWidget extends StatelessWidget {
  // Basic properties
  final String? keyName;
  final String? labelText;
  final String? hintText;
  final DateTime? initialValue;
  final Function(DateTime?)? onChange;
  final String? Function(DateTime?)? validator;

  // Visual styling
  final bool isFill;
  final Color? fillColor;
  final InputBorder? inputBorder;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showCursor;
  final Color? cursorColor;
  final double cursorWidth;
  final Radius? cursorRadius;

  // Validation and requirements
  final bool isRequired;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  // Date/Time configuration
  final InputType inputType;
  final DateFormat? dateFormat;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final DateTime? currentDate;
  final TimeOfDay initialTime;

  // Advanced picker options
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final TimePickerEntryMode timePickerInitialEntryMode;
  final Locale? locale;
  final ui.TextDirection? textDirection;
  final bool useRootNavigator;
  final TransitionBuilder? transitionBuilder;
  final SelectableDayPredicate? selectableDayPredicate;
  final bool barrierDismissible;
  final Offset? anchorPoint;
  final EntryModeChangeCallback? onEntryModeChanged;

  // Text input properties
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool expands;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<DateTime?>? onFieldSubmitted;
  final MouseCursor? mouseCursor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextCapitalization textCapitalization;
  final StrutStyle? strutStyle;
  final InputCounterWidgetBuilder? buildCounter;

  // Dialog customization
  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final String? helpText;
  final RouteSettings? routeSettings;

  // Focus and keyboard
  final FocusNode? focusNode;
  final String? restorationId;

  const DateTimePickerWidget({
    super.key,
    this.keyName,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.onChange,
    this.validator,

    // Visual styling
    this.isFill = true,
    this.fillColor,
    this.inputBorder,
    this.contentPadding,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.showCursor = false,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorRadius,

    // Validation and requirements
    this.isRequired = true,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.disabled,

    // Date/Time configuration
    this.inputType = InputType.date,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.currentDate,
    this.initialTime = const TimeOfDay(hour: 12, minute: 0),

    // Advanced picker options
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.timePickerInitialEntryMode = TimePickerEntryMode.dial,
    this.locale,
    this.textDirection,
    this.useRootNavigator = true,
    this.transitionBuilder,
    this.selectableDayPredicate,
    this.barrierDismissible = true,
    this.anchorPoint,
    this.onEntryModeChanged,

    // Text input properties
    this.controller,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.mouseCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.textCapitalization = TextCapitalization.none,
    this.strutStyle,
    this.buildCounter,

    // Dialog customization
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.helpText,
    this.routeSettings,

    // Focus and keyboard
    this.focusNode,
    this.restorationId,
  });

  /// Factory constructor for date-only picker
  factory DateTimePickerWidget.date({
    Key? key,
    String? keyName,
    String? labelText,
    DateTime? initialValue,
    Function(DateTime?)? onChange,
    String? Function(DateTime?)? validator,
    bool isRequired = true,
    bool enabled = true,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    SelectableDayPredicate? selectableDayPredicate,
    // Visual styling
    bool isFill = true,
    Color? fillColor,
    InputBorder? inputBorder,
    EdgeInsets? contentPadding,
    TextStyle? style,
    TextStyle? labelStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    // Advanced options
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    Locale? locale,
    String? helpText,
    String? cancelText,
    String? confirmText,
    FocusNode? focusNode,
  }) {
    return DateTimePickerWidget(
      key: key,
      keyName: keyName,
      labelText: labelText,
      initialValue: initialValue,
      onChange: onChange,
      validator: validator,
      isRequired: isRequired,
      enabled: enabled,
      inputType: InputType.date,
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      selectableDayPredicate: selectableDayPredicate,
      isFill: isFill,
      fillColor: fillColor,
      inputBorder: inputBorder,
      contentPadding: contentPadding,
      style: style,
      labelStyle: labelStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      initialDatePickerMode: initialDatePickerMode,
      initialEntryMode: initialEntryMode,
      locale: locale,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      focusNode: focusNode,
    );
  }

  /// Factory constructor for time-only picker
  factory DateTimePickerWidget.time({
    Key? key,
    String? keyName,
    String? labelText,
    DateTime? initialValue,
    Function(DateTime?)? onChange,
    String? Function(DateTime?)? validator,
    bool isRequired = true,
    bool enabled = true,
    TimeOfDay initialTime = const TimeOfDay(hour: 12, minute: 0),
    TimePickerEntryMode timePickerInitialEntryMode = TimePickerEntryMode.dial,
    // Visual styling
    bool isFill = true,
    Color? fillColor,
    InputBorder? inputBorder,
    EdgeInsets? contentPadding,
    TextStyle? style,
    TextStyle? labelStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    // Advanced options
    Locale? locale,
    String? helpText,
    String? cancelText,
    String? confirmText,
    FocusNode? focusNode,
  }) {
    return DateTimePickerWidget(
      key: key,
      keyName: keyName,
      labelText: labelText,
      initialValue: initialValue,
      onChange: onChange,
      validator: validator,
      isRequired: isRequired,
      enabled: enabled,
      inputType: InputType.time,
      initialTime: initialTime,
      timePickerInitialEntryMode: timePickerInitialEntryMode,
      isFill: isFill,
      fillColor: fillColor,
      inputBorder: inputBorder,
      contentPadding: contentPadding,
      style: style,
      labelStyle: labelStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      locale: locale,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      focusNode: focusNode,
    );
  }

  /// Factory constructor for date and time picker
  factory DateTimePickerWidget.dateTime({
    Key? key,
    String? keyName,
    String? labelText,
    DateTime? initialValue,
    Function(DateTime?)? onChange,
    String? Function(DateTime?)? validator,
    bool isRequired = true,
    bool enabled = true,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    TimeOfDay initialTime = const TimeOfDay(hour: 12, minute: 0),
    SelectableDayPredicate? selectableDayPredicate,
    // Visual styling
    bool isFill = true,
    Color? fillColor,
    InputBorder? inputBorder,
    EdgeInsets? contentPadding,
    TextStyle? style,
    TextStyle? labelStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    // Advanced options
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    TimePickerEntryMode timePickerInitialEntryMode = TimePickerEntryMode.dial,
    Locale? locale,
    String? helpText,
    String? cancelText,
    String? confirmText,
    FocusNode? focusNode,
  }) {
    return DateTimePickerWidget(
      key: key,
      keyName: keyName,
      labelText: labelText,
      initialValue: initialValue,
      onChange: onChange,
      validator: validator,
      isRequired: isRequired,
      enabled: enabled,
      inputType: InputType.both,
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      initialTime: initialTime,
      selectableDayPredicate: selectableDayPredicate,
      isFill: isFill,
      fillColor: fillColor,
      inputBorder: inputBorder,
      contentPadding: contentPadding,
      style: style,
      labelStyle: labelStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      initialDatePickerMode: initialDatePickerMode,
      initialEntryMode: initialEntryMode,
      timePickerInitialEntryMode: timePickerInitialEntryMode,
      locale: locale,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      focusNode: focusNode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Default format based on input type
    DateFormat getDefaultFormat() {
      final languageCode = locale?.languageCode;
      return switch (inputType) {
        InputType.time => DateFormat.Hm(languageCode),
        InputType.date => dateFormat ?? DateFormat('dd/MM/yyyy', languageCode),
        InputType.both =>
          dateFormat ?? DateFormat('dd/MM/yyyy HH:mm', languageCode),
      };
    }

    // Default hint text based on input type
    String getDefaultHintText() {
      return switch (inputType) {
        InputType.time => 'HH:mm',
        InputType.date => 'dd/MM/yyyy',
        InputType.both => 'dd/MM/yyyy HH:mm',
      };
    }

    // Default suffix icon based on input type
    Widget getDefaultSuffixIcon() {
      return switch (inputType) {
        InputType.time => const Icon(Icons.access_time_outlined),
        InputType.date => const Icon(Icons.calendar_today_outlined),
        InputType.both => const Icon(Icons.event_outlined),
      };
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (labelText != null) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: RichText(
              text: TextSpan(
                text: labelText!,
                style:
                    labelStyle ??
                    theme.bodyMedium!.copyWith(
                      color: enabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          UiHelper.verticalSpaceTiny,
        ],

        // Enhanced FormBuilderDateTimePicker
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: FormBuilderDateTimePicker(
            // Basic properties
            name: keyName ?? 'dateTimePicker',
            initialValue: initialValue,
            onChanged: onChange,
            validator:
                validator ??
                (isRequired
                    ? FormBuilderValidators.required(
                        errorText: errorInvalidText ?? 'هذا الحقل مطلوب',
                      )
                    : null),
            enabled: enabled,
            autovalidateMode: autovalidateMode,
            focusNode: focusNode,
            restorationId: restorationId,

            // Date/Time configuration
            inputType: inputType,
            format: getDefaultFormat(),
            firstDate: firstDate ?? DateTime(1900),
            lastDate: lastDate ?? DateTime(2100),
            initialDate: initialDate,
            currentDate: currentDate,
            initialTime: initialTime,

            // Advanced picker options
            initialDatePickerMode: initialDatePickerMode,
            initialEntryMode: initialEntryMode,
            timePickerInitialEntryMode: timePickerInitialEntryMode,
            locale: locale,
            textDirection: textDirection,
            useRootNavigator: useRootNavigator,
            transitionBuilder: transitionBuilder,
            selectableDayPredicate: selectableDayPredicate,
            barrierDismissible: barrierDismissible,
            anchorPoint: anchorPoint,
            onEntryModeChanged: onEntryModeChanged,

            // Text input properties
            controller: controller,
            keyboardType: keyboardType,
            style: style ?? theme.bodyMedium,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            autofocus: autofocus,
            obscureText: obscureText,
            autocorrect: autocorrect,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            expands: expands,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            onEditingComplete: onEditingComplete,
            onFieldSubmitted: onFieldSubmitted,
            showCursor: showCursor,
            cursorColor: cursorColor ?? colorScheme.primary,
            cursorWidth: cursorWidth,
            cursorRadius: cursorRadius,
            mouseCursor: mouseCursor,
            keyboardAppearance: keyboardAppearance,
            scrollPadding: scrollPadding,
            enableInteractiveSelection: enableInteractiveSelection,
            textCapitalization: textCapitalization,
            strutStyle:
                strutStyle ?? const StrutStyle(fontSize: 16.0, height: 1.2),
            buildCounter: buildCounter,

            // Dialog customization
            cancelText: cancelText ?? 'إلغاء',
            confirmText: confirmText ?? 'موافق',
            errorFormatText: errorFormatText ?? 'تنسيق التاريخ غير صحيح',
            errorInvalidText: errorInvalidText ?? 'التاريخ غير صالح',
            fieldHintText: fieldHintText ?? hintText ?? getDefaultHintText(),
            fieldLabelText: fieldLabelText,
            helpText: helpText,
            routeSettings: routeSettings,

            // Enhanced decoration
            decoration: InputDecoration(
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              filled: isFill,
              fillColor:
                  fillColor ??
                  (enabled
                      ? colorScheme.surface
                      : colorScheme.onSurface.withValues(alpha: 0.04)),

              // Icons
              prefixIcon: prefixIcon,
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: suffixIcon ?? getDefaultSuffixIcon(),
              ),

              // Hint styling
              hintText: hintText ?? getDefaultHintText(),
              hintStyle:
                  hintStyle ??
                  theme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),

              // Border styling
              border: isFill
                  ? inputBorder ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        )
                  : InputBorder.none,

              enabledBorder: isFill
                  ? inputBorder ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        )
                  : InputBorder.none,

              focusedBorder: isFill
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2.0,
                      ),
                    )
                  : InputBorder.none,

              errorBorder: isFill
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1.0,
                      ),
                    )
                  : InputBorder.none,

              focusedErrorBorder: isFill
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 2.0,
                      ),
                    )
                  : InputBorder.none,

              disabledBorder: isFill
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: colorScheme.onSurface.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                    )
                  : InputBorder.none,

              // Error styling
              errorStyle: TextStyle(color: colorScheme.error, fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }
}
