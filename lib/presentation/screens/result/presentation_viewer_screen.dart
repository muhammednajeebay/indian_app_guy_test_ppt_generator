import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import '../../../domain/entities/presentation.dart';
import '../../../core/utils/logger.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/custom_error_widget.dart';

class PresentationViewerScreen extends StatefulWidget {
  final Presentation presentation;

  const PresentationViewerScreen({super.key, required this.presentation});

  @override
  State<PresentationViewerScreen> createState() =>
      _PresentationViewerScreenState();
}

class _PresentationViewerScreenState extends State<PresentationViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String errorMessage = '';
  WebViewController? _webViewController;
  bool _isPdf = false;

  @override
  void initState() {
    super.initState();
    _checkFileTypeAndLoad();
  }

  void _checkFileTypeAndLoad() {
    final url = widget.presentation.url;
    if (url.toLowerCase().endsWith('.pdf')) {
      _isPdf = true;
      _loadPdf();
    } else {
      _isPdf = false;
      _initWebView(url);
    }
  }

  void _initWebView(String url) {
    if (!mounted) return;

    final encodedUrl = Uri.encodeComponent(url);
    final viewerUrl =
        'https://view.officeapps.live.com/op/embed.aspx?src=$encodedUrl';

    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) setState(() => isLoading = true);
            },
            onPageFinished: (String url) {
              if (mounted) setState(() => isLoading = false);
            },
            onWebResourceError: (WebResourceError error) {
              redPrint('WebView Error: ${error.description}');
            },
          ),
        )
        ..loadRequest(Uri.parse(viewerUrl));
    } catch (e) {
      redPrint('WebView Init Error: $e');
      setState(() {
        errorMessage = 'Failed to initialize viewer: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadPdf() async {
    try {
      final url = widget.presentation.url;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final request = await http.get(Uri.parse(url));
      final bytes = request.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');

      await file.writeAsBytes(bytes, flush: true);
      if (mounted) {
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      }
    } catch (e) {
      redPrint('Error loading PDF: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load PDF: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.presentation.title)),
      body: Stack(
        children: [
          if (_isPdf && localPath != null)
            PDFView(
              filePath: localPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onError: (error) {
                redPrint(error.toString());
              },
              onPageError: (page, error) {
                redPrint('$page: ${error.toString()}');
              },
            )
          else if (!_isPdf && _webViewController != null)
            WebViewWidget(controller: _webViewController!),

          if (isLoading) const Center(child: CustomLoadingIndicator()),

          if (errorMessage.isNotEmpty)
            Center(child: CustomErrorWidget(message: errorMessage)),
        ],
      ),
    );
  }
}
