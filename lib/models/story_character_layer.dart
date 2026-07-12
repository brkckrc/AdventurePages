class StoryCharacterLayer {
  const StoryCharacterLayer({
    required this.id,
    required this.assetPath,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.idleAnimation,
    this.tapAnimation,
    this.isInteractive = false,
    this.dialogueText,
    this.tapSoundEffect,
  });

  final String id;
  final String assetPath;
  final double x;
  final double y;
  final double width;
  final double height;
  final String? idleAnimation;
  final String? tapAnimation;
  final bool isInteractive;
  final String? dialogueText;
  final String? tapSoundEffect;
}
