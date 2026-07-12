import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/story_controller.dart';
import '../data/demo_story_data.dart';
import '../models/character_type.dart';
import '../models/story_character_layer.dart';
import '../models/story_choice.dart';
import '../models/story_page.dart';
import '../models/story_save_data.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';
import '../widgets/choice_button.dart';
import '../widgets/narration_box.dart';
import '../widgets/story_background.dart';
import 'chapter_end_screen.dart';
import 'home_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({
    super.key,
    required this.characterType,
    required this.heroName,
    required this.friendName,
    this.audioService,
    this.saveService,
  }) : savedState = null;

  StoryScreen.fromSave({
    super.key,
    required this.savedState,
    this.audioService,
    this.saveService,
  }) : characterType = savedState!.selectedCharacterType,
       heroName = savedState.heroName,
       friendName = savedState.friendName;

  final CharacterType characterType;
  final String heroName;
  final String friendName;
  final AudioService? audioService;
  final SaveService? saveService;
  final StorySaveData? savedState;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late final StoryController _controller;
  late final AudioService _audioService;
  late final SaveService _saveService;
  bool _isPanelVisible = true;

  @override
  void initState() {
    super.initState();
    _audioService = widget.audioService ?? AudioService();
    _saveService = widget.saveService ?? SaveService();
    _controller = StoryController(
      pages: demoStoryPages,
      initialPageId: initialStoryPageId,
      characterType: widget.characterType,
      heroName: widget.heroName,
      friendName: widget.friendName,
      chapterEndPageIds: demoChapterEndPageIds,
      savedState: widget.savedState,
      audioService: _audioService,
      saveService: _saveService,
    );

    if (widget.savedState == null) {
      unawaited(_controller.startNewStory());
    } else {
      unawaited(_controller.continueStory());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isChapterCompleted) {
          return ChapterEndScreen(
            onHome: _goHome,
            onRestart: _restartCandyChapter,
          );
        }

        final page = _controller.currentPage;

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _StoryScene(
                  key: ValueKey('story-scene-${page.id}'),
                  page: page,
                  audioService: _audioService,
                  onBackgroundTap: _togglePanelVisibility,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StoryTopBar(onHome: _goHome),
                      const Spacer(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          final slideAnimation = Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: _isPanelVisible
                            ? _StoryPanel(
                                key: ValueKey('panel-${page.id}'),
                                page: page,
                                heroName: _controller.heroName,
                                friendName: _controller.friendName,
                                onChoiceSelected: _controller.chooseOption,
                              )
                            : _ShowTextHint(
                                key: const ValueKey('show-text-hint'),
                                onPressed: _showPanel,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              if (page.showTitleCard && page.titleCardText != null)
                _TitleCardOverlay(
                  key: ValueKey('title-card-${page.id}'),
                  text: _resolvePlaceholders(page.titleCardText!),
                ),
            ],
          ),
        );
      },
    );
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(saveService: _saveService),
      ),
      (route) => false,
    );
  }

  Future<void> _restartCandyChapter() async {
    await _controller.restartStory(fromPageId: candyChapterStartPageId);
    if (!mounted) {
      return;
    }

    setState(() {
      _isPanelVisible = true;
    });
  }

  void _togglePanelVisibility() {
    setState(() {
      _isPanelVisible = !_isPanelVisible;
    });
  }

  void _showPanel() {
    if (_isPanelVisible) {
      return;
    }

    setState(() {
      _isPanelVisible = true;
    });
  }

  String _resolvePlaceholders(String text) {
    return text
        .replaceAll('{{heroName}}', _controller.heroName)
        .replaceAll('{{friendName}}', _controller.friendName);
  }
}

class _StoryTopBar extends StatelessWidget {
  const _StoryTopBar({required this.onHome});

  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Ana ekran',
          onPressed: onHome,
          icon: const Icon(Icons.home_rounded),
        ),
      ],
    );
  }
}

class _ShowTextHint extends StatelessWidget {
  const _ShowTextHint({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: const Icon(Icons.menu_book_rounded, size: 18),
        label: const Text('Metni göster'),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.48),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _TitleCardOverlay extends StatefulWidget {
  const _TitleCardOverlay({super.key, required this.text});

  final String text;

  @override
  State<_TitleCardOverlay> createState() => _TitleCardOverlayState();
}

class _TitleCardOverlayState extends State<_TitleCardOverlay> {
  bool _isVisible = true;
  bool _shouldRender = true;
  Timer? _hideTimer;
  Timer? _removeTimer;

  @override
  void initState() {
    super.initState();
    _hideTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _isVisible = false;
      });

      _removeTimer = Timer(const Duration(milliseconds: 260), () {
        if (!mounted) {
          return;
        }

        setState(() {
          _shouldRender = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _removeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldRender) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _isVisible ? Offset.zero : const Offset(-0.06, 0),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.48),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryScene extends StatefulWidget {
  const _StoryScene({
    super.key,
    required this.page,
    required this.audioService,
    required this.onBackgroundTap,
  });

  final StoryPage page;
  final AudioService audioService;
  final VoidCallback onBackgroundTap;

  @override
  State<_StoryScene> createState() => _StorySceneState();
}

class _StorySceneState extends State<_StoryScene> {
  bool _useLayeredFallback = false;
  bool _fallbackUpdateScheduled = false;

  @override
  void didUpdateWidget(covariant _StoryScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.id != widget.page.id) {
      _useLayeredFallback = false;
      _fallbackUpdateScheduled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = widget.page;
    if (page.characterLayers.isEmpty) {
      return GestureDetector(
        key: ValueKey('story-background-${page.id}'),
        behavior: HitTestBehavior.opaque,
        onTap: widget.onBackgroundTap,
        child: StoryBackground(backgroundImage: page.backgroundImage),
      );
    }

    if (_useLayeredFallback) {
      return GestureDetector(
        key: ValueKey('story-fallback-${page.id}'),
        behavior: HitTestBehavior.opaque,
        onTap: widget.onBackgroundTap,
        child: StoryBackground(
          backgroundImage: page.fallbackBackgroundImage ?? page.backgroundImage,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          key: ValueKey('story-background-${page.id}'),
          behavior: HitTestBehavior.opaque,
          onTap: widget.onBackgroundTap,
          child: StoryBackground(
            backgroundImage: page.backgroundImage,
            onImageError: _showLayeredFallback,
          ),
        ),
        _StoryCharacterLayers(
          layers: page.characterLayers,
          audioService: widget.audioService,
          onAssetError: _showLayeredFallback,
        ),
      ],
    );
  }

  void _showLayeredFallback() {
    if (_useLayeredFallback || _fallbackUpdateScheduled) {
      return;
    }

    _fallbackUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _useLayeredFallback) {
        return;
      }

      setState(() {
        _useLayeredFallback = true;
        _fallbackUpdateScheduled = false;
      });
    });
  }
}

class _StoryCharacterLayers extends StatelessWidget {
  const _StoryCharacterLayers({
    required this.layers,
    required this.audioService,
    required this.onAssetError,
  });

  final List<StoryCharacterLayer> layers;
  final AudioService audioService;
  final VoidCallback onAssetError;

  @override
  Widget build(BuildContext context) {
    if (layers.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            for (final layer in layers)
              Positioned(
                left: constraints.maxWidth * layer.x,
                top: constraints.maxHeight * layer.y,
                width: constraints.maxWidth * layer.width,
                height: constraints.maxHeight * layer.height,
                child: _StoryCharacterLayerView(
                  key: ValueKey('character-layer-${layer.id}'),
                  layer: layer,
                  audioService: audioService,
                  onAssetError: onAssetError,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StoryCharacterLayerView extends StatefulWidget {
  const _StoryCharacterLayerView({
    super.key,
    required this.layer,
    required this.audioService,
    required this.onAssetError,
  });

  final StoryCharacterLayer layer;
  final AudioService audioService;
  final VoidCallback onAssetError;

  @override
  State<_StoryCharacterLayerView> createState() =>
      _StoryCharacterLayerViewState();
}

class _StoryCharacterLayerViewState extends State<_StoryCharacterLayerView>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _tapController;
  Timer? _dialogueTimer;
  bool _showDialogue = false;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _dialogueTimer?.cancel();
    _idleController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedBuilder(
      animation: Listenable.merge([_idleController, _tapController]),
      builder: (context, child) {
        final idleValue = widget.layer.idleAnimation == null
            ? 0.0
            : Curves.easeInOut.transform(_idleController.value);
        final tapValue = widget.layer.tapAnimation == null
            ? 0.0
            : Curves.easeOutBack.transform(_tapController.value);
        final idleOffset = -6.0 * idleValue;
        final idleScale = 1 + (0.018 * idleValue);
        final squashX = 1 + (0.12 * tapValue);
        final squashY = 1 - (0.08 * tapValue);

        return Transform.translate(
          offset: Offset(0, idleOffset),
          child: Transform.scale(
            scaleX: idleScale * squashX,
            scaleY: idleScale * squashY,
            child: child,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(
              widget.layer.assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                widget.onAssetError();
                return const SizedBox.shrink();
              },
            ),
          ),
          if (_showDialogue && widget.layer.dialogueText != null)
            Positioned(
              left: -12,
              right: -12,
              top: -34,
              child: _CharacterDialogueBubble(text: widget.layer.dialogueText!),
            ),
        ],
      ),
    );

    if (!widget.layer.isInteractive) {
      return IgnorePointer(child: content);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: content,
    );
  }

  Future<void> _handleTap() async {
    _dialogueTimer?.cancel();
    setState(() {
      _showDialogue = true;
    });

    _tapController.forward(from: 0).then((_) {
      if (mounted) {
        _tapController.reverse();
      }
    });

    _dialogueTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _showDialogue = false;
      });
    });

    await widget.audioService.playSfx(widget.layer.tapSoundEffect);
  }
}

class _CharacterDialogueBubble extends StatelessWidget {
  const _CharacterDialogueBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF28342F),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel({
    super.key,
    required this.page,
    required this.heroName,
    required this.friendName,
    required this.onChoiceSelected,
  });

  final StoryPage page;
  final String heroName;
  final String friendName;
  final ValueChanged<StoryChoice> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final panelHeight = (screenHeight * 0.50).clamp(132.0, 360.0).toDouble();
    final narrationText = _resolvePlaceholders(page.narrationText);

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: SizedBox(
            height: panelHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ScrollablePanelSection(
                    showHint: screenHeight < 430,
                    child: NarrationBox(narrationText: narrationText),
                  ),
                ),
                const SizedBox(height: 10),
                _ChoiceArea(
                  choices: page.choices,
                  maxHeight: (panelHeight * 0.60).clamp(86.0, 180.0).toDouble(),
                  onChoiceSelected: onChoiceSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _resolvePlaceholders(String text) {
    return text
        .replaceAll('{{heroName}}', heroName)
        .replaceAll('{{friendName}}', friendName);
  }
}

class _ChoiceArea extends StatelessWidget {
  const _ChoiceArea({
    required this.choices,
    required this.maxHeight,
    required this.onChoiceSelected,
  });

  final List<StoryChoice> choices;
  final double maxHeight;
  final ValueChanged<StoryChoice> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    if (choices.length == 1) {
      final choice = choices.single;

      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180),
          child: ChoiceButton(
            key: ValueKey('choice-button-${choice.nextPageId}'),
            text: choice.text,
            onPressed: () => onChoiceSelected(choice),
          ),
        ),
      );
    }

    return SizedBox(
      height: maxHeight,
      child: _ScrollablePanelSection(
        showHint: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final choice in choices)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ChoiceButton(
                  key: ValueKey('choice-button-${choice.nextPageId}'),
                  text: choice.text,
                  onPressed: () => onChoiceSelected(choice),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScrollablePanelSection extends StatefulWidget {
  const _ScrollablePanelSection({required this.child, required this.showHint});

  final Widget child;
  final bool showHint;

  @override
  State<_ScrollablePanelSection> createState() =>
      _ScrollablePanelSectionState();
}

class _ScrollablePanelSectionState extends State<_ScrollablePanelSection> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = widget.showHint ? 18.0 : 0.0;

    return Stack(
      children: [
        Scrollbar(
          controller: _controller,
          thumbVisibility: widget.showHint,
          child: SingleChildScrollView(
            controller: _controller,
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: widget.child,
          ),
        ),
        if (widget.showHint)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.24),
                    ],
                  ),
                ),
                child: const SizedBox(
                  height: 24,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
