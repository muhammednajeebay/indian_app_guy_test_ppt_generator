import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorWidget extends StatelessWidget {
  final double width;
  final double height;
  final String animationPath;
  final String message;

  const CustomErrorWidget({
    super.key,
    this.width = 200,
    this.height = 200,
    this.animationPath = 'assets/animations/failed.json',
    this.message = 'Something went wrong!',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animationPath,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
