import 'package:adventure_pages/models/character_type.dart';
import 'package:adventure_pages/models/story_save_data.dart';
import 'package:adventure_pages/services/save_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('save service persists and restores the complete story state', () async {
    final service = SaveService();
    const expected = StorySaveData(
      selectedCharacterType: CharacterType.girl,
      heroName: 'Lale',
      friendName: 'Aras',
      currentPageId: 'castle_view',
      currentChapterId: 'candy_land',
      lastCheckpointPageId: 'castle_view',
      isChapterCompleted: true,
    );

    expect(await service.saveProgress(expected), isTrue);
    final restored = await service.loadProgress();

    expect(restored, isNotNull);
    expect(restored?.selectedCharacterType, CharacterType.girl);
    expect(restored?.heroName, 'Lale');
    expect(restored?.friendName, 'Aras');
    expect(restored?.currentPageId, 'castle_view');
    expect(restored?.currentChapterId, 'candy_land');
    expect(restored?.lastCheckpointPageId, 'castle_view');
    expect(restored?.hasSave, isTrue);
    expect(restored?.isChapterCompleted, isTrue);
  });

  test('clearProgress removes the local story save', () async {
    final service = SaveService();
    const savedState = StorySaveData(
      selectedCharacterType: CharacterType.boy,
      heroName: 'Aras',
      friendName: 'Mina',
      currentPageId: 'play_outside',
      currentChapterId: 'intro',
      lastCheckpointPageId: 'front_yard_meeting',
    );

    await service.saveProgress(savedState);
    expect(await service.hasProgress(), isTrue);

    await service.clearProgress();

    expect(await service.hasProgress(), isFalse);
    expect(await service.loadProgress(), isNull);
  });

  test(
    'corrupt or incomplete preferences are cleared without throwing',
    () async {
      SharedPreferences.setMockInitialValues({
        'story.hasSave': true,
        'story.selectedCharacterType': 'unknown_character',
        'story.heroName': 'Mina',
        'story.friendName': 'Aras',
        'story.currentPageId': 'candy_land',
        'story.currentChapterId': 'candy_land',
      });
      final service = SaveService();

      expect(await service.loadProgress(), isNull);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getBool('story.hasSave'), isNull);
    },
  );
}
