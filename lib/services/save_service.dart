import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character_type.dart';
import '../models/story_save_data.dart';

typedef SharedPreferencesLoader = Future<SharedPreferences> Function();

class SaveService {
  SaveService({SharedPreferencesLoader? preferencesLoader})
    : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const _hasSaveKey = 'story.hasSave';
  static const _characterTypeKey = 'story.selectedCharacterType';
  static const _heroNameKey = 'story.heroName';
  static const _friendNameKey = 'story.friendName';
  static const _pageIdKey = 'story.currentPageId';
  static const _chapterIdKey = 'story.currentChapterId';
  static const _checkpointPageIdKey = 'story.lastCheckpointPageId';
  static const _chapterCompletedKey = 'story.chapterCompleted';

  static const _storyKeys = <String>[
    _hasSaveKey,
    _characterTypeKey,
    _heroNameKey,
    _friendNameKey,
    _pageIdKey,
    _chapterIdKey,
    _checkpointPageIdKey,
    _chapterCompletedKey,
  ];

  final SharedPreferencesLoader _preferencesLoader;
  Future<SharedPreferences>? _preferences;

  Future<bool> saveProgress(StorySaveData data) async {
    try {
      final preferences = await _getPreferences();
      await preferences.setBool(_hasSaveKey, false);
      await preferences.setString(
        _characterTypeKey,
        data.selectedCharacterType.name,
      );
      await preferences.setString(_heroNameKey, data.heroName);
      await preferences.setString(_friendNameKey, data.friendName);
      await preferences.setString(_pageIdKey, data.currentPageId);
      await preferences.setString(_chapterIdKey, data.currentChapterId);

      final checkpointPageId = data.lastCheckpointPageId;
      if (checkpointPageId == null || checkpointPageId.isEmpty) {
        await preferences.remove(_checkpointPageIdKey);
      } else {
        await preferences.setString(_checkpointPageIdKey, checkpointPageId);
      }

      await preferences.setBool(_chapterCompletedKey, data.isChapterCompleted);
      await preferences.setBool(_hasSaveKey, data.hasSave);
      return true;
    } on Object catch (error) {
      debugPrint('SaveService.saveProgress failed: $error');
      return false;
    }
  }

  Future<StorySaveData?> loadProgress() async {
    SharedPreferences? preferences;

    try {
      preferences = await _getPreferences();
      if (preferences.getBool(_hasSaveKey) != true) {
        return null;
      }

      final characterType = _parseCharacterType(
        preferences.getString(_characterTypeKey),
      );
      final heroName = preferences.getString(_heroNameKey)?.trim();
      final friendName = preferences.getString(_friendNameKey)?.trim();
      final pageId = preferences.getString(_pageIdKey)?.trim();
      final chapterId = preferences.getString(_chapterIdKey)?.trim();

      if (characterType == null ||
          heroName == null ||
          heroName.isEmpty ||
          friendName == null ||
          friendName.isEmpty ||
          pageId == null ||
          pageId.isEmpty ||
          chapterId == null ||
          chapterId.isEmpty) {
        debugPrint('SaveService.loadProgress found an incomplete story save.');
        await _clearPreferences(preferences);
        return null;
      }

      return StorySaveData(
        selectedCharacterType: characterType,
        heroName: heroName,
        friendName: friendName,
        currentPageId: pageId,
        currentChapterId: chapterId,
        lastCheckpointPageId: preferences
            .getString(_checkpointPageIdKey)
            ?.trim(),
        isChapterCompleted: preferences.getBool(_chapterCompletedKey) ?? false,
      );
    } on Object catch (error) {
      debugPrint('SaveService.loadProgress failed: $error');
      if (preferences != null) {
        await _clearPreferences(preferences);
      }
      return null;
    }
  }

  Future<bool> hasProgress() async {
    return await loadProgress() != null;
  }

  Future<void> clearProgress() async {
    try {
      await _clearPreferences(await _getPreferences());
    } on Object catch (error) {
      debugPrint('SaveService.clearProgress failed: $error');
    }
  }

  Future<SharedPreferences> _getPreferences() {
    return _preferences ??= _preferencesLoader();
  }

  CharacterType? _parseCharacterType(String? value) {
    for (final characterType in CharacterType.values) {
      if (characterType.name == value) {
        return characterType;
      }
    }

    return null;
  }

  Future<void> _clearPreferences(SharedPreferences preferences) async {
    for (final key in _storyKeys) {
      await preferences.remove(key);
    }
  }
}
