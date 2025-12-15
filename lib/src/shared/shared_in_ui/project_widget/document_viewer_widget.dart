import 'dart:io';

import '/src/shared/shared_in_ui/project_widget/auto_direction_text.dart';
import '/src/shared/shared_in_ui/project_widget/pdf_reader_widget.dart';
import '/src/shared/shared_in_ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/language/app_strings.dart';

/// Supported document types for in-app viewing
enum DocumentType { pdf, word, excel, powerpoint, other }

/// Document Viewer Widget that supports viewing various document types
/// - PDF: Uses native PDF viewer
/// - Word/Excel/PowerPoint: Uses Google Docs Viewer via WebView
/// - Other: Opens with external app
class DocumentViewerWidget extends StatefulWidget {
  static const String id = '/DocumentViewerWidget';

  const DocumentViewerWidget({super.key});

  @override
  State<DocumentViewerWidget> createState() => _DocumentViewerWidgetState();
}

class _DocumentViewerWidgetState extends State<DocumentViewerWidget> {
  String? documentUrl;
  File? localFile;
  String fileName = '';
  DocumentType documentType = DocumentType.other;
  bool isLoading = true;
  String? errorMessage;
  double loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initializeDocument();
  }

  void _initializeDocument() {
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      documentUrl = args['url'] as String?;
      localFile = args['file'] as File?;
      fileName = args['fileName'] as String? ?? _extractFileName();
    } else if (args is String) {
      documentUrl = args;
      fileName = _extractFileName();
    } else if (args is File) {
      localFile = args;
      fileName = localFile!.path.split('/').last;
    }

    documentType = _getDocumentType(fileName);

    // For PDF with local file, navigate to PDF reader
    if (documentType == DocumentType.pdf && localFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => const PdfReaderWidget(), arguments: localFile);
      });
      return;
    }

    // For PDF with URL, navigate to PDF reader
    if (documentType == DocumentType.pdf && documentUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => const PdfReaderWidget(), arguments: documentUrl);
      });
      return;
    }

    // For unsupported types with local file, open externally
    if (documentType == DocumentType.other && localFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openExternally(localFile!.path);
        Get.back();
      });
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  String _extractFileName() {
    if (documentUrl != null) {
      final uri = Uri.tryParse(documentUrl!);
      if (uri != null) {
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          return Uri.decodeComponent(pathSegments.last);
        }
      }
    }
    if (localFile != null) {
      return localFile!.path.split('/').last;
    }
    return 'document';
  }

  DocumentType _getDocumentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    switch (extension) {
      case 'pdf':
        return DocumentType.pdf;
      case 'doc':
      case 'docx':
        return DocumentType.word;
      case 'xls':
      case 'xlsx':
        return DocumentType.excel;
      case 'ppt':
      case 'pptx':
        return DocumentType.powerpoint;
      default:
        return DocumentType.other;
    }
  }

  String _getGoogleDocsViewerUrl(String fileUrl) {
    final encodedUrl = Uri.encodeComponent(fileUrl);
    return 'https://docs.google.com/gview?embedded=true&url=$encodedUrl';
  }

  Future<void> _openExternally(String path) async {
    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      Get.snackbar(
        AppStrings.error.tr.capitalizeFirst!,
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // For PDF types, this widget won't be shown (redirected in initState)
    if (documentType == DocumentType.pdf) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // For unsupported types, show message
    if (documentType == DocumentType.other) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              UiHelper.verticalSpaceMedium,
              AutoDirectionText(
                AppStrings.cannotPreviewFile.tr.capitalizeFirst ??
                    'Cannot preview this file type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              UiHelper.verticalSpaceSmall,
              if (documentUrl != null)
                ElevatedButton.icon(
                  onPressed: () async {
                    // Try to download and open
                    Get.snackbar(
                      'Info',
                      AppStrings.downloadingFile.tr.capitalizeFirst ??
                          'Downloading file...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: AutoDirectionText(
                    AppStrings.download.tr.capitalizeFirst ?? 'Download',
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // For Word, Excel, PowerPoint - use WebView with Google Docs Viewer
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          if (documentUrl != null)
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_getGoogleDocsViewerUrl(documentUrl!)),
              ),
              initialSettings: InAppWebViewSettings(
                useHybridComposition: true,
                allowsInlineMediaPlayback: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportZoom: true,
                builtInZoomControls: true,
                displayZoomControls: false,
              ),
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  loadingProgress = progress / 100;
                });
              },
              onReceivedError: (controller, request, error) {
                setState(() {
                  isLoading = false;
                  errorMessage = error.description;
                });
              },
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  UiHelper.verticalSpaceMedium,
                  AutoDirectionText(
                    AppStrings.noUrlAvailable.tr.capitalizeFirst ??
                        'No URL available for preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

          // Loading indicator
          if (isLoading)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress > 0 ? loadingProgress : null,
                    ),
                    UiHelper.verticalSpaceMedium,
                    AutoDirectionText(
                      AppStrings.loadingDocument.tr.capitalizeFirst ??
                          'Loading document...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (loadingProgress > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('${(loadingProgress * 100).toInt()}%'),
                      ),
                  ],
                ),
              ),
            ),

          // Error display
          if (errorMessage != null && !isLoading)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    UiHelper.verticalSpaceMedium,
                    AutoDirectionText(
                      AppStrings.failedToLoadDocument.tr.capitalizeFirst ??
                          'Failed to load document',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    UiHelper.verticalSpaceSmall,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AutoDirectionText(
                        errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    UiHelper.verticalSpaceMedium,
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          errorMessage = null;
                          isLoading = true;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: AutoDirectionText(
                        AppStrings.retry.tr.capitalizeFirst ?? 'Retry',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AutoDirectionText(fileName, style: const TextStyle(fontSize: 16)),
      leading: const BackButton(),
      actions: [
        if (documentUrl != null)
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip:
                AppStrings.openExternally.tr.capitalizeFirst ??
                'Open externally',
            onPressed: () async {
              // Open in browser or external app
              if (localFile != null) {
                await _openExternally(localFile!.path);
              }
            },
          ),
        if (documentUrl != null)
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              // Share functionality
            },
          ),
      ],
    );
  }
}

/// Helper class for document type utilities
class DocumentTypeHelper {
  static const List<String> pdfExtensions = ['pdf'];
  static const List<String> wordExtensions = ['doc', 'docx'];
  static const List<String> excelExtensions = ['xls', 'xlsx'];
  static const List<String> powerpointExtensions = ['ppt', 'pptx'];

  static List<String> get supportedExtensions => [
    ...pdfExtensions,
    ...wordExtensions,
    ...excelExtensions,
    ...powerpointExtensions,
  ];

  static bool isSupported(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return supportedExtensions.contains(extension);
  }

  static bool isPdf(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return pdfExtensions.contains(extension);
  }

  static bool isWord(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return wordExtensions.contains(extension);
  }

  static bool isExcel(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return excelExtensions.contains(extension);
  }

  static bool isPowerpoint(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return powerpointExtensions.contains(extension);
  }

  static DocumentType getType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    if (pdfExtensions.contains(extension)) return DocumentType.pdf;
    if (wordExtensions.contains(extension)) return DocumentType.word;
    if (excelExtensions.contains(extension)) return DocumentType.excel;
    if (powerpointExtensions.contains(extension)) {
      return DocumentType.powerpoint;
    }
    return DocumentType.other;
  }

  static IconData getIcon(String fileName) {
    final type = getType(fileName);
    switch (type) {
      case DocumentType.pdf:
        return Icons.picture_as_pdf;
      case DocumentType.word:
        return Icons.description;
      case DocumentType.excel:
        return Icons.table_chart;
      case DocumentType.powerpoint:
        return Icons.slideshow;
      case DocumentType.other:
        return Icons.insert_drive_file;
    }
  }

  static Color getColor(String fileName) {
    final type = getType(fileName);
    switch (type) {
      case DocumentType.pdf:
        return const Color(0xFFE53935); // Red
      case DocumentType.word:
        return const Color(0xFF2196F3); // Blue
      case DocumentType.excel:
        return const Color(0xFF4CAF50); // Green
      case DocumentType.powerpoint:
        return const Color(0xFFFF9800); // Orange
      case DocumentType.other:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  static String getTypeName(String fileName) {
    final type = getType(fileName);
    switch (type) {
      case DocumentType.pdf:
        return 'PDF';
      case DocumentType.word:
        return 'Word';
      case DocumentType.excel:
        return 'Excel';
      case DocumentType.powerpoint:
        return 'PowerPoint';
      case DocumentType.other:
        final extension = fileName.toLowerCase().split('.').last;
        return extension.toUpperCase();
    }
  }
}
