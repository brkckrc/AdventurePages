import 'package:adventure_pages/app.dart';
import 'package:adventure_pages/data/demo_story_data.dart';
import 'package:adventure_pages/models/character_type.dart';
import 'package:adventure_pages/models/story_save_data.dart';
import 'package:adventure_pages/screens/story_screen.dart';
import 'package:adventure_pages/services/audio_service.dart';
import 'package:adventure_pages/services/save_service.dart';
import 'package:adventure_pages/widgets/choice_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemorySaveService extends SaveService {
  _MemorySaveService({this.data});

  StorySaveData? data;
  int saveCount = 0;
  int clearCount = 0;

  @override
  Future<bool> saveProgress(StorySaveData value) async {
    saveCount += 1;
    data = value;
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

class _FakeAudioService extends AudioService {
  _FakeAudioService() : super(playbackEnabled: false);

  String? playedSfx;

  @override
  Future<void> playSfx(String? assetPath) async {
    playedSfx = assetPath;
  }

  @override
  Future<void> stopAll() async {}
}

class _FailingAssetBundle extends CachingAssetBundle {
  _FailingAssetBundle(this.failingAsset);

  final String failingAsset;

  @override
  Future<ByteData> load(String key) {
    if (key == failingAsset) {
      return Future<ByteData>.error(
        FlutterError('Intentional test failure for $key'),
      );
    }
    return rootBundle.load(key);
  }
}

StorySaveData _savedAt(
  String pageId, {
  String? checkpointPageId,
  bool isCompleted = false,
  CharacterType characterType = CharacterType.girl,
  String? heroName,
}) {
  return StorySaveData(
    selectedCharacterType: characterType,
    heroName: heroName ?? characterType.defaultHeroName,
    friendName: characterType.defaultFriendName,
    currentPageId: pageId,
    currentChapterId: demoStoryPages[pageId]?.chapterId ?? 'candy_land',
    lastCheckpointPageId: checkpointPageId,
    isChapterCompleted: isCompleted,
  );
}

Future<void> _pumpHome(
  WidgetTester tester,
  _MemorySaveService saveService,
) async {
  await tester.pumpWidget(AdventurePagesApp(saveService: saveService));
  await tester.pumpAndSettle();
}

Future<void> _startWithCharacter(
  WidgetTester tester, {
  required String characterLabel,
  String? customName,
}) async {
  await tester.tap(find.byKey(const ValueKey('new-story-button')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(characterLabel));
  await tester.pumpAndSettle();
  if (customName != null) {
    await tester.enterText(find.byType(EditableText), customName);
  }
  await tester.tap(find.text('Hikayeye başla'));
  await tester.pumpAndSettle();
}

Future<void> _pumpSavedStory(
  WidgetTester tester, {
  required StorySaveData savedState,
  required _MemorySaveService saveService,
  AudioService? audioService,
  AssetBundle? assetBundle,
}) async {
  final story = StoryScreen.fromSave(
    savedState: savedState,
    saveService: saveService,
    audioService: audioService,
  );

  await tester.pumpWidget(
    MaterialApp(
      home: assetBundle == null
          ? story
          : DefaultAssetBundle(bundle: assetBundle, child: story),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 120));
}

void main() {
  testWidgets('home shows New Story and hides Continue without a save', (
    tester,
  ) async {
    await _pumpHome(tester, _MemorySaveService());

    expect(find.text('Adventure Pages'), findsOneWidget);
    expect(find.text('Yeni Hikâye'), findsOneWidget);
    expect(find.text('Devam Et'), findsNothing);
    expect(find.textContaining('Gökyüzü'), findsNothing);
    expect(find.textContaining('Denizler'), findsNothing);
    expect(find.textContaining('Ejderha'), findsNothing);
  });

  testWidgets('boy selection uses Aras and Mina when name is blank', (
    tester,
  ) async {
    final saveService = _MemorySaveService();
    await _pumpHome(tester, saveService);

    await _startWithCharacter(tester, characterLabel: 'Erkek karakter');

    expect(find.textContaining('Aras ve Mina güneş yavaşça'), findsOneWidget);
    expect(find.textContaining('{{heroName}}'), findsNothing);
    expect(find.textContaining('{{friendName}}'), findsNothing);
    expect(saveService.data?.selectedCharacterType, CharacterType.boy);
    expect(saveService.data?.heroName, 'Aras');
    expect(saveService.data?.friendName, 'Mina');
  });

  testWidgets('girl selection uses Mina and Aras when name is blank', (
    tester,
  ) async {
    final saveService = _MemorySaveService();
    await _pumpHome(tester, saveService);

    await _startWithCharacter(tester, characterLabel: 'Kız karakter');

    expect(find.textContaining('Mina ve Aras güneş yavaşça'), findsOneWidget);
    expect(saveService.data?.selectedCharacterType, CharacterType.girl);
    expect(saveService.data?.heroName, 'Mina');
    expect(saveService.data?.friendName, 'Aras');
  });

  testWidgets('custom hero name is shown and persisted with the friend name', (
    tester,
  ) async {
    final saveService = _MemorySaveService();
    await _pumpHome(tester, saveService);

    await _startWithCharacter(
      tester,
      characterLabel: 'Kız karakter',
      customName: 'Lale',
    );

    expect(find.textContaining('Lale ve Aras güneş yavaşça'), findsOneWidget);
    expect(saveService.data?.heroName, 'Lale');
    expect(saveService.data?.friendName, 'Aras');
  });

  testWidgets('Continue opens the saved scene without character selection', (
    tester,
  ) async {
    final savedState = _savedAt(
      'look_around',
      checkpointPageId: 'pofuduk_meeting',
    );
    final saveService = _MemorySaveService(data: savedState);
    await _pumpHome(tester, saveService);

    expect(find.text('Devam Et'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('continue-story-button')));
    await tester.pumpAndSettle();

    expect(find.text('Karakter Seçimi'), findsNothing);
    expect(find.textContaining('şeker çiçeklerinin arasında'), findsOneWidget);
    expect(saveService.data?.currentPageId, 'look_around');
  });

  testWidgets('New Story confirms before clearing an existing save', (
    tester,
  ) async {
    final saveService = _MemorySaveService(
      data: _savedAt('castle_view', checkpointPageId: 'castle_view'),
    );
    await _pumpHome(tester, saveService);

    await tester.tap(find.byKey(const ValueKey('new-story-button')));
    await tester.pumpAndSettle();
    expect(
      find.text('Mevcut ilerleme silinecek. Yeni hikâye başlatılsın mı?'),
      findsOneWidget,
    );

    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();
    expect(saveService.data, isNotNull);

    await tester.tap(find.byKey(const ValueKey('new-story-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yeni Hikâye Başlat'));
    await tester.pumpAndSettle();

    expect(find.text('Karakter Seçimi'), findsOneWidget);
    expect(saveService.data, isNull);
    expect(saveService.clearCount, 1);
  });

  testWidgets('title card and narration panel keep their existing behavior', (
    tester,
  ) async {
    final saveService = _MemorySaveService();
    await tester.pumpWidget(
      MaterialApp(
        home: StoryScreen(
          characterType: CharacterType.girl,
          heroName: 'Mina',
          friendName: 'Aras',
          saveService: saveService,
        ),
      ),
    );

    expect(find.text('ADVENTURE PAGES'), findsOneWidget);
    expect(find.text('Evin Önünde Buluşma'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
    expect(find.text('ADVENTURE PAGES'), findsNothing);

    final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;
    await tester.tapAt(Offset(screenSize.width - 40, 64));
    await tester.pumpAndSettle();
    expect(find.text('Metni göster'), findsOneWidget);
    expect(find.textContaining('Mina ve Aras güneş yavaşça'), findsNothing);

    await tester.tap(find.text('Metni göster'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mina ve Aras güneş yavaşça'), findsOneWidget);
  });

  testWidgets('compact landscape character and story UI does not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final saveService = _MemorySaveService();
    await _pumpHome(tester, saveService);
    await tester.tap(find.byKey(const ValueKey('new-story-button')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Kız karakter'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Hikayeye başla'));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Hikayeye başla'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Devam et'), findsOneWidget);
  });

  testWidgets('Pofuduk layer tap shows dialogue, keeps panel, and plays WAV', (
    tester,
  ) async {
    final savedState = _savedAt(
      'pofuduk_meeting',
      checkpointPageId: 'pofuduk_meeting',
    );
    final saveService = _MemorySaveService(data: savedState);
    final audioService = _FakeAudioService();
    await _pumpSavedStory(
      tester,
      savedState: savedState,
      saveService: saveService,
      audioService: audioService,
    );

    final pofuduk = find.byKey(const ValueKey('character-layer-pofuduk'));
    expect(pofuduk, findsOneWidget);
    expect(find.byKey(const ValueKey('panel-pofuduk_meeting')), findsOneWidget);

    await tester.tapAt(tester.getTopLeft(pofuduk) + const Offset(30, 30));
    await tester.pump();

    expect(find.text('Pof! Hey, gıdıklanıyorum!'), findsOneWidget);
    expect(find.text('Metni göster'), findsNothing);
    expect(find.byKey(const ValueKey('panel-pofuduk_meeting')), findsOneWidget);
    expect(audioService.playedSfx, pofudukBounceSound);

    await tester.pump(const Duration(milliseconds: 2200));
    expect(find.text('Pof! Hey, gıdıklanıyorum!'), findsNothing);
  });

  testWidgets('layered Pofuduk scene falls back to the combined image', (
    tester,
  ) async {
    final savedState = _savedAt(
      'pofuduk_meeting',
      checkpointPageId: 'pofuduk_meeting',
    );
    final saveService = _MemorySaveService(data: savedState);
    await _pumpSavedStory(
      tester,
      savedState: savedState,
      saveService: saveService,
      assetBundle: _FailingAssetBundle(candyVillageBackground),
    );

    final fallback = find.byKey(
      const ValueKey('story-fallback-pofuduk_meeting'),
    );
    for (
      var attempt = 0;
      attempt < 10 && fallback.evaluate().isEmpty;
      attempt++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(fallback, findsOneWidget);
    expect(find.byKey(const ValueKey('character-layer-pofuduk')), findsNothing);
    final image = tester.widget<Image>(
      find.descendant(of: fallback, matching: find.byType(Image)),
    );
    expect((image.image as AssetImage).assetName, candyPofudukImage);
    expect(tester.takeException(), isNull);
  });

  testWidgets('first meaningful choice opens its selected short path', (
    tester,
  ) async {
    final savedState = _savedAt(
      'first_candy_choice',
      checkpointPageId: 'pofuduk_meeting',
    );
    final saveService = _MemorySaveService(data: savedState);
    await _pumpSavedStory(
      tester,
      savedState: savedState,
      saveService: saveService,
    );

    expect(find.text('Pofuduk\'u takip et'), findsOneWidget);
    expect(find.text('Önce etrafı incele'), findsOneWidget);
    await tester.tap(find.text('Önce etrafı incele'));
    await tester.pumpAndSettle();

    expect(saveService.data?.currentPageId, 'look_around');
    expect(find.textContaining('şeker çiçeklerinin arasında'), findsOneWidget);
  });

  testWidgets('chapter end is reachable and restart keeps character identity', (
    tester,
  ) async {
    final savedState = _savedAt(
      'bay_bayat_shadow',
      checkpointPageId: 'castle_view',
      characterType: CharacterType.girl,
      heroName: 'Lale',
    );
    final saveService = _MemorySaveService(data: savedState);
    await _pumpSavedStory(
      tester,
      savedState: savedState,
      saveService: saveService,
    );

    final finishButton = find.byKey(
      const ValueKey('choice-button-candy_chapter_end'),
    );
    tester.widget<ChoiceButton>(finishButton).onPressed();
    await tester.pumpAndSettle();

    expect(find.text('Şeker Kalesi'), findsOneWidget);
    expect(find.text('Macera Devam Edecek'), findsOneWidget);
    expect(saveService.data?.isChapterCompleted, isTrue);

    await tester.tap(find.byKey(const ValueKey('chapter-end-restart-button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Lale ve Aras pamuk şeker'), findsOneWidget);
    expect(saveService.data?.currentPageId, candyChapterStartPageId);
    expect(saveService.data?.heroName, 'Lale');
    expect(saveService.data?.friendName, 'Aras');
    expect(saveService.data?.isChapterCompleted, isFalse);
  });

  testWidgets('chapter end can return to the main menu without world cards', (
    tester,
  ) async {
    final savedState = _savedAt(
      'bay_bayat_shadow',
      checkpointPageId: 'castle_view',
      isCompleted: true,
    );
    final saveService = _MemorySaveService(data: savedState);
    await _pumpSavedStory(
      tester,
      savedState: savedState,
      saveService: saveService,
    );

    expect(find.text('Macera Devam Edecek'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('chapter-end-home-button')));
    await tester.pumpAndSettle();

    expect(find.text('Adventure Pages'), findsOneWidget);
    expect(find.text('Devam Et'), findsOneWidget);
    expect(find.textContaining('Kilitli'), findsNothing);
    expect(find.textContaining('Diyarı'), findsNothing);
  });
}
