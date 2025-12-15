import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoDirectionText extends StatefulWidget {
  final String? text;
  final TextStyle? style;
  final AlignmentGeometry? alignment;
  final int? maxLines;
  final double? minFontSize;
  final double? widthFactor;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;

  // final Function  onReadMore;

  const AutoDirectionText(
    this.text, {
    super.key,
    this.style,
    this.alignment,
    this.maxLines,
    this.textAlign,
    this.minFontSize,
    this.textOverflow,
    this.widthFactor,
  });

  @override
  _InputTextFieldWidgetState createState() => _InputTextFieldWidgetState();
}

class _InputTextFieldWidgetState extends State<AutoDirectionText> {
  String? text;
  bool isRTL = false;
  String? tempText;

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  void didUpdateWidget(covariant AutoDirectionText oldWidget) {
    if (oldWidget.text != widget.text) {
      setState(() {
        text = widget.text;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //text ?? 'no data',
    //       textAlign: text?.isNotEmpty == true
    //           ? (text!.codeUnitAt(0) > 127 ? TextAlign.right : TextAlign.left)
    //           : TextAlign.left,
    //       textDirection: text?.isNotEmpty == true
    //           ? (text!.codeUnitAt(0) > 127 ? TextDirection.rtl : TextDirection.ltr)
    //           : TextDirection.ltr,
    //       style: style ?? Theme.of(context).textTheme.bodyMedium,
    //       maxLines: maxLines,
    //       overflow: textOverflow ?? TextOverflow.ellipsis,
    return AutoDirection(
      text: "$text",
      child: widget.widthFactor != null || widget.alignment != null
          ? Align(
              widthFactor: widget.widthFactor,
              alignment: widget.alignment ?? AlignmentDirectional.centerStart,
              child: Text(
                widget.text ?? 'no data',
                maxLines: widget.maxLines,
                softWrap: true,
                textAlign: widget.textAlign,
                style: widget.style,
              ),
            )
          : Text(
              widget.text ?? 'no data',
              maxLines: widget.maxLines,
              softWrap: true,
              textAlign: widget.textAlign,
              style: widget.style,
            ),
    );
  }
}
