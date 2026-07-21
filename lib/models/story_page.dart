import 'character_reaction.dart';
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
    this.showHeroLayers = true,
    this.boyDefaultPose = CharacterPose.idle,
    this.girlDefaultPose = CharacterPose.idle,
    this.boyTapReactions = const [],
    this.girlTapReactions = const [],
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
  final bool showHeroLayers;
  final CharacterPose boyDefaultPose;
  final CharacterPose girlDefaultPose;
  final List<CharacterReaction> boyTapReactions;
  final List<CharacterReaction> girlTapReactions;
  final List<StoryChoice> choices;
}
