import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../domain/entities/presentation.dart';
import '../../../core/utils/logger.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/custom_button.dart';
import 'presentation_viewer_screen.dart';

class ResultScreen extends StatefulWidget {
  final Presentation presentation;

  const ResultScreen({super.key, required this.presentation});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isDownloading = false;

  Future<void> _downloadPdf() async {
    setState(() {
      isDownloading = true;
    });

    try {
      final url = widget.presentation.url;
      final extension = url.split('.').last;
      final filename =
          "Presentation_${DateTime.now().millisecondsSinceEpoch}.$extension";

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
          // Fallback for Android 13+
          directory = await getExternalStorageDirectory();
        }
      } else {
        // iOS
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final savePath = "${directory.path}/$filename";
        // Use Dio for download
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
          isDownloading = false;
        });
      }
    }
  }

  void _navigateToViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PresentationViewerScreen(presentation: widget.presentation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presentation Ready')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.presentation.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your presentation has been generated successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 48),

                CustomButton(
                  text: 'View Presentation',
                  icon: Icons.visibility,
                  onPressed: _navigateToViewer,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: isDownloading ? null : _downloadPdf,
                  icon: const Icon(Icons.download),
                  label: const Text('Download File'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          if (isDownloading) const Center(child: CustomLoadingIndicator()),
        ],
      ),
    );
  }
}
