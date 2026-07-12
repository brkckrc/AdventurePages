import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/story_page.dart';

class AudioService {
  AudioService({AudioPlayer? sfxPlayer, bool playbackEnabled = true})
    : _sfxPlayer = sfxPlayer ?? (playbackEnabled ? AudioPlayer() : null);

  final AudioPlayer? _sfxPlayer;
  String? _activeEntryEffect;
  String? _activeAmbientSound;
  String? _lastSfx;

  Future<void> onPageChanged(StoryPage page) async {
    await playEntryEffect(page.entrySoundEffect);
    await playAmbient(page.ambientSound);
  }

  Future<void> playEntryEffect(String? path) async {
    _activeEntryEffect = path == null || path.isEmpty ? null : path;
  }

  Future<void> playAmbient(String? path) async {
    if (path == null || path.isEmpty) {
      await stopAmbient();
      return;
    }

    _activeAmbientSound = path;
  }

  Future<void> stopAmbient() async {
    _activeAmbientSound = null;
  }

  Future<void> playSfx(String? assetPath) async {
    if (assetPath == null || assetPath.isEmpty) {
      _lastSfx = null;
      return;
    }

    _lastSfx = assetPath;
    final sfxPlayer = _sfxPlayer;
    if (sfxPlayer == null) {
      return;
    }

    try {
      await sfxPlayer.stop();
      await sfxPlayer.setVolume(1.0);
      await sfxPlayer.play(AssetSource(_assetSourcePath(assetPath)));
    } on Exception catch (error) {
      debugPrint('AudioService.playSfx failed for "$assetPath": $error');
    }
  }

  Future<void> stopSceneSound() async {
    _activeEntryEffect = null;
  }

  Future<void> stopAll() async {
    _activeEntryEffect = null;
    _activeAmbientSound = null;
    await _sfxPlayer?.stop();
  }

  String? get activeEntryEffect => _activeEntryEffect;
  String? get activeAmbientSound => _activeAmbientSound;
  String? get lastSfx => _lastSfx;

  String _assetSourcePath(String assetPath) {
    const assetPrefix = 'assets/';
    if (assetPath.startsWith(assetPrefix)) {
      return assetPath.substring(assetPrefix.length);
    }

    return assetPath;
  }
}
