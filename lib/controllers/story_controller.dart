import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/character_type.dart';
import '../models/story_choice.dart';
import '../models/story_page.dart';
import '../models/story_save_data.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';

class StoryController extends ChangeNotifier {
  StoryController({
    required this.pages,
    required this.initialPageId,
    required CharacterType characterType,
    required String heroName,
    required String friendName,
    this.chapterEndPageIds = const {},
    StorySaveData? savedState,
    AudioService? audioService,
    SaveService? saveService,
  }) : _characterType = characterType,
       _heroName = heroName.trim(),
       _friendName = friendName.trim(),
       _currentPageId = initialPageId,
       _audioService = audioService ?? AudioService(),
       _saveService = saveService ?? SaveService() {
    _normalizeNames();
    if (savedState == null) {
      _resetToPage(_safeInitialPageId);
    } else {
      _applySavedState(savedState);
    }
  }

  static const StoryPage _missingPage = StoryPage(
    id: 'missing_story_page',
    backgroundImage: '',
    title: 'Hikaye Sahnesi',
    narrationText:
        'Bu sahne yüklenemedi. Ana menüye dönüp tekrar deneyebilirsin.',
    choices: [],
  );

  final Map<String, StoryPage> pages;
  final String initialPageId;
  final Set<String> chapterEndPageIds;
  final AudioService _audioService;
  final SaveService _saveService;

  CharacterType _characterType;
  String _heroName;
  String _friendName;
  String _currentPageId;
  String? _lastCheckpointPageId;
  bool _isChapterCompleted = false;
  bool _navigationLocked = false;

  CharacterType get characterType => _characterType;
  String get heroName => _heroName;
  String get friendName => _friendName;
  String get currentPageId => _currentPageId;
  String? get lastCheckpointPageId => _lastCheckpointPageId;
  bool get isChapterCompleted => _isChapterCompleted;
  bool get isNavigationLocked => _navigationLocked;

  StoryPage get currentPage {
    return pages[_currentPageId] ??
        pages[_safeInitialPageId] ??
        (pages.isEmpty ? _missingPage : pages.values.first);
  }

  Future<void> startNewStory() async {
    await _runWithNavigationLock(() async {
      await clearProgress();
      _resetToPage(_safeInitialPageId);
      notifyListeners();
      await _handlePageChanged();
    });
  }

  Future<bool> continueStory() async {
    if (_navigationLocked) {
      return false;
    }

    _navigationLocked = true;
    try {
      final savedState = await loadProgress();
      if (savedState == null) {
        return false;
      }

      final isValid = _applySavedState(savedState);
      notifyListeners();
      await _handlePageChanged();
      return isValid;
    } finally {
      _navigationLocked = false;
    }
  }

  Future<void> saveProgress() async {
    final page = currentPage;
    final data = StorySaveData(
      selectedCharacterType: _characterType,
      heroName: _heroName,
      friendName: _friendName,
      currentPageId: page.id,
      currentChapterId: page.chapterId ?? 'intro',
      lastCheckpointPageId: _lastCheckpointPageId,
      isChapterCompleted: _isChapterCompleted,
    );

    try {
      await _saveService.saveProgress(data);
    } on Object catch (error) {
      debugPrint('StoryController.saveProgress failed: $error');
    }
  }

  Future<StorySaveData?> loadProgress() async {
    try {
      return await _saveService.loadProgress();
    } on Object catch (error) {
      debugPrint('StoryController.loadProgress failed: $error');
      return null;
    }
  }

  Future<void> clearProgress() async {
    try {
      await _saveService.clearProgress();
    } on Object catch (error) {
      debugPrint('StoryController.clearProgress failed: $error');
    }
  }

  Future<void> restartStory({String? fromPageId}) async {
    await _runWithNavigationLock(() async {
      final requestedPageId = fromPageId ?? initialPageId;
      final restartPageId = pages.containsKey(requestedPageId)
          ? requestedPageId
          : _safeInitialPageId;

      if (restartPageId != requestedPageId) {
        debugPrint(
          'StoryController.restartStory could not find "$requestedPageId". '
          'Using "$restartPageId" instead.',
        );
      }

      _resetToPage(restartPageId);
      notifyListeners();
      await _handlePageChanged();
    });
  }

  Future<void> restart() => restartStory();

  Future<void> goToPage(String pageId) async {
    await _runWithNavigationLock(() => _goToPageUnlocked(pageId));
  }

  Future<void> chooseOption(StoryChoice choice) async {
    await _runWithNavigationLock(
      () => _goToPageUnlocked(
        choice.nextPageId,
        source: 'choice "${choice.text}"',
      ),
    );
  }

  Future<void> selectChoice(StoryChoice choice) => chooseOption(choice);

  Future<void> returnToCheckpoint() async {
    await _runWithNavigationLock(() async {
      final checkpointPageId = _lastCheckpointPageId;
      final checkpointPage = checkpointPageId == null
          ? null
          : pages[checkpointPageId];

      if (checkpointPage == null || !checkpointPage.isCheckpoint) {
        debugPrint(
          'StoryController.returnToCheckpoint could not resolve '
          '"$checkpointPageId". Using the story start.',
        );
        _resetToPage(_safeInitialPageId);
      } else {
        _currentPageId = checkpointPage.id;
        _isChapterCompleted = false;
      }

      notifyListeners();
      await _handlePageChanged();
    });
  }

  Future<void> _goToPageUnlocked(
    String pageId, {
    String source = 'navigation',
  }) async {
    if (chapterEndPageIds.contains(pageId)) {
      _isChapterCompleted = true;
      notifyListeners();
      await saveProgress();
      return;
    }

    final page = pages[pageId];
    if (page == null) {
      debugPrint(
        'StoryController ignored invalid page "$pageId" from $source.',
      );
      return;
    }

    _currentPageId = page.id;
    _isChapterCompleted = false;
    if (page.isCheckpoint) {
      _lastCheckpointPageId = page.id;
    }

    notifyListeners();
    await _handlePageChanged();
  }

  Future<void> _handlePageChanged() async {
    await _audioService.onPageChanged(currentPage);
    await saveProgress();
  }

  Future<void> _runWithNavigationLock(Future<void> Function() operation) async {
    if (_navigationLocked) {
      return;
    }

    _navigationLocked = true;
    try {
      await operation();
    } finally {
      _navigationLocked = false;
    }
  }

  bool _applySavedState(StorySaveData savedState) {
    _characterType = savedState.selectedCharacterType;
    _heroName = savedState.heroName.trim();
    _friendName = savedState.friendName.trim();
    _normalizeNames();

    final savedPage = pages[savedState.currentPageId];
    final savedChapterMatches =
        savedPage != null &&
        (savedPage.chapterId ?? 'intro') == savedState.currentChapterId;

    if (!savedChapterMatches) {
      debugPrint(
        'StoryController found invalid saved page/chapter '
        '"${savedState.currentPageId}"/"${savedState.currentChapterId}". '
        'Using the story start.',
      );
      _resetToPage(_safeInitialPageId);
      return false;
    }

    _currentPageId = savedPage.id;
    _isChapterCompleted = savedState.isChapterCompleted;

    final savedCheckpointId = savedState.lastCheckpointPageId;
    final savedCheckpoint = savedCheckpointId == null
        ? null
        : pages[savedCheckpointId];
    if (savedCheckpoint != null && savedCheckpoint.isCheckpoint) {
      _lastCheckpointPageId = savedCheckpoint.id;
    } else {
      if (savedCheckpointId != null && savedCheckpointId.isNotEmpty) {
        debugPrint(
          'StoryController ignored invalid checkpoint '
          '"$savedCheckpointId".',
        );
      }
      _lastCheckpointPageId = savedPage.isCheckpoint
          ? savedPage.id
          : _initialCheckpointPageId;
    }

    return true;
  }

  void _resetToPage(String pageId) {
    _currentPageId = pages.containsKey(pageId) ? pageId : _safeInitialPageId;
    _isChapterCompleted = false;
    final page = pages[_currentPageId];
    _lastCheckpointPageId = page?.isCheckpoint == true
        ? page?.id
        : _initialCheckpointPageId;
  }

  void _normalizeNames() {
    if (_heroName.isEmpty) {
      _heroName = _characterType.defaultHeroName;
    }
    if (_friendName.isEmpty) {
      _friendName = _characterType.defaultFriendName;
    }
  }

  String get _safeInitialPageId {
    if (pages.containsKey(initialPageId)) {
      return initialPageId;
    }
    if (pages.isNotEmpty) {
      return pages.keys.first;
    }
    return _missingPage.id;
  }

  String? get _initialCheckpointPageId {
    final initialPage = pages[_safeInitialPageId];
    return initialPage?.isCheckpoint == true ? initialPage?.id : null;
  }

  @override
  void dispose() {
    unawaited(_audioService.stopAll());
    super.dispose();
  }
}
