import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../domain/entities/presentation.dart';
import '../../../core/utils/logger.dart';

class ResultScreen extends StatefulWidget {
  final Presentation presentation;

  const ResultScreen({super.key, required this.presentation});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? localPath;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPdf();
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
      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      redPrint('Error loading PDF: $e');
      setState(() {
        errorMessage = 'Failed to load PDF: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _downloadPdf() async {
    // Basic download simulation or implementation based on platform
    // For now, showing a snackbar as proper download involves permission handling complexities on Android 10+
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download functionality to be implemented fully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.presentation.title),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: _downloadPdf),
        ],
      ),
      body: Stack(
        children: [
          if (localPath != null)
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
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (errorMessage.isNotEmpty) Center(child: Text(errorMessage)),
        ],
      ),
    );
  }
}
