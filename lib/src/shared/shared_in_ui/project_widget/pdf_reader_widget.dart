import 'dart:io';

// Auto-size-text import removed
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import '/src/core/language/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';

import 'auto_direction_text.dart';

class PdfReaderWidget extends StatefulWidget {
  static const String id = '/PdfReaderWidget';

  const PdfReaderWidget({super.key});

  @override
  _PdfReaderWidgetState createState() => _PdfReaderWidgetState();
}

class _PdfReaderWidgetState extends State<PdfReaderWidget> {
  String? docUrl;
  File? file;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is String) {
      docUrl = Get.arguments;
    }
    if (Get.arguments is File) {
      file = Get.arguments;
      if (kDebugMode) {
        print('file: $file');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            file != null
                ? const PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                  ).fromPath(file!.path)
                : PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    defaultPage: 0,
                    fitEachPage: true,
                    nightMode: false,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    gestureRecognizers:
                        <Factory<OneSequenceGestureRecognizer>>{},
                    onViewCreated: null,
                    onRender: null,
                    onPageChanged: null,
                    onError: null,
                    onPageError: null,
                    onLinkHandler: null,
                    password: null,
                    preventLinkNavigation: true,
                    pageSnap: true,
                    fitPolicy: FitPolicy.BOTH,
                  ).cachedFromUrl(
                    docUrl ?? '',
                    placeholder: (progress) =>
                        Center(child: UiHelper.spinKitProgressIndicator()),
                    errorWidget: (error) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error,
                            color: Theme.of(context).primaryColor,
                            size: 48,
                          ),
                          UiHelper.verticalSpaceMedium,
                          AutoDirectionText(
                            AppStrings.invalidDocUrl.tr.capitalizeFirst!,
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
            BackButton(),
          ],
        ),
      ),
    );
  }
}
