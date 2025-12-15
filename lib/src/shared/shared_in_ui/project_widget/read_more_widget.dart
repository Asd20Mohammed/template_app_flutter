import 'package:auto_direction/auto_direction.dart';
import '/src/core/language/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ReadMoreWidget extends StatefulWidget {
  final String? text;
  final int? trimLines;
  final AlignmentGeometry? alignment;
  final Function(bool)? onReadMore;
  final TextAlign? textAlign;
  final TextStyle? style;

  const ReadMoreWidget({
    super.key,
    this.text,
    this.alignment,
    this.trimLines,
    this.onReadMore,
    this.textAlign,
    this.style,
  });

  @override
  _ReadMoreWidgetState createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends State<ReadMoreWidget> {
  String? text;
  bool isRTL = false;
  String? tempText;

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  void didUpdateWidget(covariant ReadMoreWidget oldWidget) {
    if (oldWidget.text != widget.text) {
      setState(() {
        text = widget.text;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AutoDirection(
      text: text!,
      child: ReadMoreText(
        widget.text!,
        trimLines: widget.trimLines ?? 3,

        colorClickableText: Theme.of(context).primaryColor,
        trimMode: TrimMode.Line,
        // callback: widget.onReadMore,
        textAlign: widget.textAlign,
        // textScaler: Get.find<TextScaleService>().appTextScaler.value,
        trimCollapsedText: AppStrings.showMore.tr.capitalizeFirst!,
        trimExpandedText: AppStrings.showLess.tr.capitalizeFirst!,
      ),
    );
  }
}
