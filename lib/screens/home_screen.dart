import 'package:flutter/material.dart';

import '../models/story_save_data.dart';
import '../services/save_service.dart';
import 'character_select_screen.dart';
import 'story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.saveService});

  final SaveService? saveService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SaveService _saveService = widget.saveService ?? SaveService();
  StorySaveData? _savedStory;
  bool _isLoading = true;
  bool _isOpeningStory = false;

  @override
  void initState() {
    super.initState();
    _refreshSavedStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF184D47), Color(0xFF4B8F8C), Color(0xFFF5C46B)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (constraints.maxHeight - 48).clamp(
                      0.0,
                      double.infinity,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Adventure Pages',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Çizgi roman tadında seçimli bir hikaye',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFEAF8F5),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          else ...[
                            if (_savedStory != null) ...[
                              FilledButton.icon(
                                key: const ValueKey('continue-story-button'),
                                onPressed: _isOpeningStory
                                    ? null
                                    : _continueStory,
                                icon: const Icon(Icons.menu_book_rounded),
                                label: const Text('Devam Et'),
                                style: _primaryButtonStyle(),
                              ),
                              const SizedBox(height: 12),
                            ],
                            OutlinedButton.icon(
                              key: const ValueKey('new-story-button'),
                              onPressed: _isOpeningStory
                                  ? null
                                  : _startNewStory,
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Yeni Hikâye'),
                              style: _secondaryButtonStyle(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF184D47),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  ButtonStyle _secondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white70),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Future<void> _refreshSavedStory() async {
    final savedStory = await _saveService.loadProgress();
    if (!mounted) {
      return;
    }

    setState(() {
      _savedStory = savedStory;
      _isLoading = false;
    });
  }

  Future<void> _startNewStory() async {
    if (_savedStory != null) {
      final shouldStart = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Yeni Hikâye'),
            content: const Text(
              'Mevcut ilerleme silinecek. Yeni hikâye başlatılsın mı?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yeni Hikâye Başlat'),
              ),
            ],
          );
        },
      );

      if (shouldStart != true || !mounted) {
        return;
      }
    }

    setState(() {
      _isOpeningStory = true;
    });
    await _saveService.clearProgress();
    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CharacterSelectScreen(saveService: _saveService),
      ),
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _isOpeningStory = false;
    });
    await _refreshSavedStory();
  }

  Future<void> _continueStory() async {
    setState(() {
      _isOpeningStory = true;
    });

    final savedStory = await _saveService.loadProgress();
    if (!mounted) {
      return;
    }
    if (savedStory == null) {
      setState(() {
        _savedStory = null;
        _isOpeningStory = false;
      });
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StoryScreen.fromSave(
          savedState: savedStory,
          saveService: _saveService,
        ),
      ),
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _isOpeningStory = false;
    });
    await _refreshSavedStory();
  }
}
