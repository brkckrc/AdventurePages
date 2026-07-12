import 'package:flutter/material.dart';

import '../models/story_background_motion.dart';

class StoryBackground extends StatefulWidget {
  const StoryBackground({
    super.key,
    required this.backgroundImage,
    this.motion = StoryBackgroundMotion.none,
    this.onImageError,
  });

  final String backgroundImage;
  final StoryBackgroundMotion motion;
  final VoidCallback? onImageError;

  @override
  State<StoryBackground> createState() => _StoryBackgroundState();
}

class _StoryBackgroundState extends State<StoryBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _startMotion();
  }

  @override
  void didUpdateWidget(covariant StoryBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.motion != widget.motion ||
        oldWidget.backgroundImage != widget.backgroundImage) {
      _startMotion();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = SizedBox.expand(
      child: Image.asset(
        widget.backgroundImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          widget.onImageError?.call();
          return const _FallbackStoryBackground();
        },
      ),
    );

    if (widget.motion == StoryBackgroundMotion.none) {
      return image;
    }

    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        child: image,
        builder: (context, child) {
          final progress = Curves.easeInOut.transform(_controller.value);
          final motion = widget.motion;

          if (motion == StoryBackgroundMotion.slowZoomIn) {
            return Transform.scale(
              key: const ValueKey('story-background-motion-slowZoomIn'),
              scale: 1 + (0.07 * progress),
              child: child,
            );
          }

          if (motion == StoryBackgroundMotion.slowZoomOut) {
            return Transform.scale(
              key: const ValueKey('story-background-motion-slowZoomOut'),
              scale: 1.07 - (0.06 * progress),
              child: child,
            );
          }

          final movesLeft = motion == StoryBackgroundMotion.panLeft;
          final startOffset = movesLeft ? 0.012 : -0.012;
          final endOffset = -startOffset;
          final horizontalOffset =
              startOffset + ((endOffset - startOffset) * progress);

          return LayoutBuilder(
            builder: (context, constraints) {
              return Transform.translate(
                key: ValueKey('story-background-motion-${motion.name}'),
                offset: Offset(constraints.maxWidth * horizontalOffset, 0),
                child: Transform.scale(scale: 1.045, child: child),
              );
            },
          );
        },
      ),
    );
  }

  void _startMotion() {
    _controller
      ..stop()
      ..duration = _durationFor(widget.motion)
      ..value = 0;

    if (widget.motion != StoryBackgroundMotion.none) {
      _controller.forward();
    }
  }

  Duration _durationFor(StoryBackgroundMotion motion) {
    return switch (motion) {
      StoryBackgroundMotion.panLeft ||
      StoryBackgroundMotion.panRight => const Duration(seconds: 12),
      StoryBackgroundMotion.none ||
      StoryBackgroundMotion.slowZoomIn ||
      StoryBackgroundMotion.slowZoomOut => const Duration(seconds: 14),
    };
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
