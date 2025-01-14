import 'dart:io';
import 'package:flutter/material.dart';

class AnimatedImageSwitcher extends StatelessWidget {
  final String imagePath;
  final Duration duration;

  const AnimatedImageSwitcher({
    super.key,
    required this.imagePath,
    this.duration = const Duration(milliseconds: 85),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Image.file(
        File(imagePath),
        key: ValueKey<String>(imagePath),
      ),
    );
  }
}
