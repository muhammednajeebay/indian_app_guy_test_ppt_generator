import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../domain/entities/presentation.dart';
import '../../../core/utils/logger.dart';
import '../../widgets/custom_loading_indicator.dart';

import '../../widgets/custom_error_widget.dart';
import '../../widgets/error_dialog.dart';

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
    setState(() {
      isLoading = true;
    });

    try {
      final url = widget.presentation.url; // Assuming this is valid
      final filename =
          "Presentation_${DateTime.now().millisecondsSinceEpoch}.pdf";

      Directory? directory;
      if (Platform.isAndroid) {
        // Request storage permission
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          // Fallback for Android 13+ regarding images/video vs generic files,
          // or just deny. For simplicty in this scope, if storage denied,
          // try externalStorageDirectory which acts as app-specific storage
          // often not needing as strict permissions on newer androids for own app dir
          directory = await getExternalStorageDirectory();
        }
      } else {
        // iOS
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final savePath = "${directory.path}/$filename";
        // Use Dio for download to get progress if needed, simple get for now
        final dio = Dio();
        await dio.download(url, savePath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloaded to $savePath'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception("Could not determine save directory");
      }
    } catch (e) {
      redPrint("Download Error: $e");
      if (mounted) {
        ErrorDialog.show(context, message: 'Failed to download: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          if (isLoading) const Center(child: CustomLoadingIndicator()),
          if (errorMessage.isNotEmpty)
            Center(child: CustomErrorWidget(message: errorMessage)),
        ],
      ),
    );
  }
}
