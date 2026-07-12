import 'dart:async';

import 'package:adventure_pages/controllers/story_controller.dart';
import 'package:adventure_pages/data/demo_story_data.dart';
import 'package:adventure_pages/models/character_type.dart';
import 'package:adventure_pages/models/story_background_motion.dart';
import 'package:adventure_pages/models/story_choice.dart';
import 'package:adventure_pages/models/story_page.dart';
import 'package:adventure_pages/models/story_save_data.dart';
import 'package:adventure_pages/services/audio_service.dart';
import 'package:adventure_pages/services/save_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySaveService extends SaveService {
  _MemorySaveService({this.data});

  StorySaveData? data;
  int saveCount = 0;
  int clearCount = 0;
  Completer<void>? nextSaveGate;

  @override
  Future<bool> saveProgress(StorySaveData value) async {
    saveCount += 1;
    data = value;
    final gate = nextSaveGate;
    if (gate != null) {
      await gate.future;
    }
    return true;
  }

  @override
  Future<StorySaveData?> loadProgress() async => data;

  @override
  Future<void> clearProgress() async {
    clearCount += 1;
    data = null;
  }
}

class _SilentAudioService extends AudioService {
  _SilentAudioService() : super(playbackEnabled: false);

  @override
  Future<void> onPageChanged(StoryPage page) async {}

  @override
  Future<void> stopAll() async {}
}

StoryController _buildController({
  required _MemorySaveService saveService,
  StorySaveData? savedState,
  CharacterType characterType = CharacterType.boy,
  String heroName = 'Aras',
  String friendName = 'Mina',
}) {
  final controller = StoryController(
    pages: demoStoryPages,
    initialPageId: initialStoryPageId,
    characterType: characterType,
    heroName: heroName,
    friendName: friendName,
    chapterEndPageIds: demoChapterEndPageIds,
    savedState: savedState,
    audioService: _SilentAudioService(),
    saveService: saveService,
  );
  addTearDown(controller.dispose);
  return controller;
}

StorySaveData _savedAt(
  String pageId, {
  String? checkpointPageId,
  bool isCompleted = false,
}) {
  return StorySaveData(
    selectedCharacterType: CharacterType.girl,
    heroName: 'Mina',
    friendName: 'Aras',
    currentPageId: pageId,
    currentChapterId: demoStoryPages[pageId]?.chapterId ?? 'candy_land',
    lastCheckpointPageId: checkpointPageId,
    isChapterCompleted: isCompleted,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('demo story is connected and only Pofuduk uses character layers', () {
    final visited = <String>{};
    final pending = <String>[initialStoryPageId];
    var reachesChapterEnd = false;

    while (pending.isNotEmpty) {
      final pageId = pending.removeLast();
      if (!visited.add(pageId)) {
        continue;
      }

      final page = demoStoryPages[pageId];
      expect(page, isNotNull, reason: 'Missing story page: $pageId');
      for (final choice in page!.choices) {
        if (demoChapterEndPageIds.contains(choice.nextPageId)) {
          reachesChapterEnd = true;
        } else {
          expect(
            demoStoryPages.containsKey(choice.nextPageId),
            isTrue,
            reason: 'Invalid target: ${choice.nextPageId}',
          );
          pending.add(choice.nextPageId);
        }
      }
    }

    expect(visited, demoStoryPages.keys.toSet());
    expect(reachesChapterEnd, isTrue);

    final layeredPages = demoStoryPages.values
        .where((page) => page.characterLayers.isNotEmpty)
        .toList();
    expect(layeredPages, hasLength(1));
    expect(layeredPages.single.id, 'pofuduk_meeting');
    expect(layeredPages.single.backgroundImage, candyVillageBackground);
    expect(layeredPages.single.fallbackBackgroundImage, candyPofudukImage);

    final pofuduk = layeredPages.single.characterLayers.single;
    expect(pofuduk.assetPath, pofudukWaveImage);
    expect(pofuduk.tapSoundEffect, pofudukBounceSound);
    expect(pofuduk.tapSoundEffect, endsWith('pofuduk_bounce.wav'));
  });

  test('demo contains no other world pages or assets', () {
    const forbiddenTerms = <String>[
      'sky',
      'sea',
      'dragon',
      'gokyuzu',
      'denizler',
      'ejderha',
    ];
    final storySurface = [
      ...demoStoryPages.keys,
      ...demoStoryPages.values.map((page) => page.backgroundImage),
    ].join(' ').toLowerCase();

    for (final term in forbiddenTerms) {
      expect(storySurface, isNot(contains(term)));
    }
  });

  test('demo pages use the intended background motions', () {
    const expectedMotions = <String, StoryBackgroundMotion>{
      'front_yard_meeting': StoryBackgroundMotion.slowZoomIn,
      'mysterious_book': StoryBackgroundMotion.panRight,
      'inspect_book': StoryBackgroundMotion.slowZoomIn,
      'book_glows': StoryBackgroundMotion.slowZoomIn,
      'portal_opens': StoryBackgroundMotion.slowZoomIn,
      'pulled_inside': StoryBackgroundMotion.slowZoomIn,
      'candy_land': StoryBackgroundMotion.slowZoomOut,
      'candy_village': StoryBackgroundMotion.panLeft,
      'pofuduk_meeting': StoryBackgroundMotion.slowZoomIn,
      'look_around': StoryBackgroundMotion.panLeft,
      'caramel_warning': StoryBackgroundMotion.panRight,
      'caramel_trap': StoryBackgroundMotion.panRight,
      'caramel_chase': StoryBackgroundMotion.panRight,
      'help_each_other': StoryBackgroundMotion.panRight,
      'castle_view': StoryBackgroundMotion.slowZoomIn,
      'bay_bayat_shadow': StoryBackgroundMotion.slowZoomIn,
    };

    for (final entry in expectedMotions.entries) {
      expect(demoStoryPages[entry.key]?.backgroundMotion, entry.value);
    }
    expect(
      demoStoryPages['play_outside']?.backgroundMotion,
      StoryBackgroundMotion.none,
    );
  });

  test(
    'startNewStory applies default names and saves the initial page',
    () async {
      final saveService = _MemorySaveService(data: _savedAt('castle_view'));
      final controller = _buildController(
        saveService: saveService,
        heroName: '',
        friendName: '',
      );

      await controller.startNewStory();

      expect(controller.currentPageId, initialStoryPageId);
      expect(controller.heroName, 'Aras');
      expect(controller.friendName, 'Mina');
      expect(saveService.clearCount, 1);
      expect(saveService.data?.currentPageId, initialStoryPageId);
      expect(saveService.data?.selectedCharacterType, CharacterType.boy);
    },
  );

  test('every successful page change saves the new progress', () async {
    final saveService = _MemorySaveService();
    final controller = _buildController(saveService: saveService);

    await controller.startNewStory();
    final savesAfterStart = saveService.saveCount;
    await controller.goToPage('play_outside');
    await controller.chooseOption(
      demoStoryPages['play_outside']!.choices.single,
    );

    expect(saveService.saveCount, savesAfterStart + 2);
    expect(saveService.data?.currentPageId, 'mysterious_book');
    expect(saveService.data?.currentChapterId, 'intro');
  });

  test('continueStory restores the saved page and identity', () async {
    final savedState = _savedAt(
      'look_around',
      checkpointPageId: 'pofuduk_meeting',
    );
    final saveService = _MemorySaveService(data: savedState);
    final controller = _buildController(saveService: saveService);

    final restored = await controller.continueStory();

    expect(restored, isTrue);
    expect(controller.currentPageId, 'look_around');
    expect(controller.characterType, CharacterType.girl);
    expect(controller.heroName, 'Mina');
    expect(controller.friendName, 'Aras');
    expect(controller.lastCheckpointPageId, 'pofuduk_meeting');
  });

  test('invalid saved page or chapter safely falls back to intro', () async {
    const invalidSave = StorySaveData(
      selectedCharacterType: CharacterType.girl,
      heroName: 'Mina',
      friendName: 'Aras',
      currentPageId: 'missing_page',
      currentChapterId: 'missing_chapter',
      lastCheckpointPageId: 'missing_checkpoint',
    );
    final saveService = _MemorySaveService(data: invalidSave);
    final controller = _buildController(
      saveService: saveService,
      savedState: invalidSave,
    );

    final restored = await controller.continueStory();

    expect(restored, isFalse);
    expect(controller.currentPageId, initialStoryPageId);
    expect(controller.lastCheckpointPageId, initialStoryPageId);
    expect(saveService.data?.currentPageId, initialStoryPageId);
  });

  test('checkpoint is saved and returnToCheckpoint restores it', () async {
    final saveService = _MemorySaveService();
    final controller = _buildController(saveService: saveService);

    await controller.startNewStory();
    await controller.goToPage('pofuduk_meeting');
    await controller.goToPage('first_candy_choice');

    expect(controller.lastCheckpointPageId, 'pofuduk_meeting');
    expect(saveService.data?.lastCheckpointPageId, 'pofuduk_meeting');

    await controller.returnToCheckpoint();

    expect(controller.currentPageId, 'pofuduk_meeting');
  });

  test('invalid saved checkpoint does not prevent continuing', () async {
    final savedState = _savedAt(
      'first_candy_choice',
      checkpointPageId: 'missing_checkpoint',
    );
    final saveService = _MemorySaveService(data: savedState);
    final controller = _buildController(
      saveService: saveService,
      savedState: savedState,
    );

    expect(controller.currentPageId, 'first_candy_choice');
    expect(controller.lastCheckpointPageId, initialStoryPageId);

    await controller.returnToCheckpoint();
    expect(controller.currentPageId, initialStoryPageId);
  });

  test('risky caramel choice returns to its checkpoint safely', () async {
    final saveService = _MemorySaveService();
    final controller = _buildController(saveService: saveService);

    await controller.goToPage('caramel_warning');
    final riskyChoice = controller.currentPage.choices.firstWhere(
      (choice) => choice.nextPageId == 'caramel_trap',
    );
    await controller.chooseOption(riskyChoice);

    expect(controller.currentPageId, 'caramel_trap');
    expect(controller.lastCheckpointPageId, 'caramel_warning');

    await controller.chooseOption(controller.currentPage.choices.single);
    expect(controller.currentPageId, 'caramel_warning');
  });

  test('invalid choice target leaves the current page unchanged', () async {
    final saveService = _MemorySaveService();
    final controller = _buildController(saveService: saveService);

    await controller.chooseOption(
      const StoryChoice(text: 'Eksik hedef', nextPageId: 'does_not_exist'),
    );

    expect(controller.currentPageId, initialStoryPageId);
    expect(saveService.saveCount, 0);
  });

  test('rapid navigation is locked to the first page transition', () async {
    final saveService = _MemorySaveService();
    final controller = _buildController(saveService: saveService);
    await controller.startNewStory();

    final gate = Completer<void>();
    saveService.nextSaveGate = gate;
    final firstTransition = controller.goToPage('play_outside');
    await Future<void>.delayed(Duration.zero);
    final secondTransition = controller.goToPage('mysterious_book');

    expect(controller.currentPageId, 'play_outside');
    gate.complete();
    await Future.wait([firstTransition, secondTransition]);

    expect(controller.currentPageId, 'play_outside');
  });

  test(
    'chapter completion is saved and restart begins at Candy Land',
    () async {
      final saveService = _MemorySaveService();
      final controller = _buildController(saveService: saveService);

      await controller.goToPage('bay_bayat_shadow');
      await controller.chooseOption(controller.currentPage.choices.single);

      expect(controller.isChapterCompleted, isTrue);
      expect(saveService.data?.isChapterCompleted, isTrue);
      expect(saveService.data?.currentPageId, 'bay_bayat_shadow');

      await controller.restartStory(fromPageId: candyChapterStartPageId);

      expect(controller.isChapterCompleted, isFalse);
      expect(controller.currentPageId, candyChapterStartPageId);
      expect(controller.heroName, 'Aras');
      expect(controller.friendName, 'Mina');
      expect(saveService.data?.currentPageId, candyChapterStartPageId);
    },
  );
}
