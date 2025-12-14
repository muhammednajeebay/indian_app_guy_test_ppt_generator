import 'package:flutter/material.dart';
import 'custom_error_widget.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.onRetry,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(title: title, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.red)),
      content: CustomErrorWidget(message: message, width: 150, height: 150),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
