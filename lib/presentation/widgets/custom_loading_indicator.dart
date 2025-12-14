import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double width;
  final double height;
  final String animationPath;

  const CustomLoadingIndicator({
    super.key,
    this.width = 200,
    this.height = 200,
    this.animationPath = 'assets/animations/loading.json',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        animationPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
