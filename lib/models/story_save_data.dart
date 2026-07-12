import 'character_type.dart';

class StorySaveData {
  const StorySaveData({
    required this.selectedCharacterType,
    required this.heroName,
    required this.friendName,
    required this.currentPageId,
    required this.currentChapterId,
    required this.lastCheckpointPageId,
    this.hasSave = true,
    this.isChapterCompleted = false,
  });

  final CharacterType selectedCharacterType;
  final String heroName;
  final String friendName;
  final String currentPageId;
  final String currentChapterId;
  final String? lastCheckpointPageId;
  final bool hasSave;
  final bool isChapterCompleted;
}
