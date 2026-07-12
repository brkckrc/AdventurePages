import 'story_choice.dart';
import 'story_background_motion.dart';
import 'story_character_layer.dart';

class StoryPage {
  const StoryPage({
    required this.id,
    required this.backgroundImage,
    required this.title,
    required this.narrationText,
    this.backgroundMotion = StoryBackgroundMotion.none,
    this.titleCardText,
    this.showTitleCard = false,
    this.chapterId,
    this.ambientSound,
    this.entrySoundEffect,
    this.isCheckpoint = false,
    this.characterLayers = const [],
    this.fallbackBackgroundImage,
    required this.choices,
  });

  final String id;
  final String backgroundImage;
  final String title;
  final String narrationText;
  final StoryBackgroundMotion backgroundMotion;
  final String? titleCardText;
  final bool showTitleCard;
  final String? chapterId;
  final String? ambientSound;
  final String? entrySoundEffect;
  final bool isCheckpoint;
  final List<StoryCharacterLayer> characterLayers;
  final String? fallbackBackgroundImage;
  final List<StoryChoice> choices;
}
