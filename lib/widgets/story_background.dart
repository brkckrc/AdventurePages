import 'package:flutter/material.dart';

class StoryBackground extends StatelessWidget {
  const StoryBackground({
    super.key,
    required this.backgroundImage,
    this.onImageError,
  });

  final String backgroundImage;
  final VoidCallback? onImageError;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        backgroundImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          onImageError?.call();
          return const _FallbackStoryBackground();
        },
      ),
    );
  }
}

class _FallbackStoryBackground extends StatelessWidget {
  const _FallbackStoryBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF23374D), Color(0xFF447A77), Color(0xFFF2C66D)],
        ),
      ),
    );
  }
}
