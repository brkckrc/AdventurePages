import 'character_reaction.dart';

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
    this.defaultPose = CharacterPose.idle,
    this.poseAssets = const {},
    this.tapReactions = const [],
    this.tapCooldown = const Duration(milliseconds: 700),
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
  final CharacterPose defaultPose;
  final Map<CharacterPose, String> poseAssets;
  final List<CharacterReaction> tapReactions;
  final Duration tapCooldown;
}
