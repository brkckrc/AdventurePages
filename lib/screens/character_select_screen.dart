import 'package:flutter/material.dart';

import '../models/character_type.dart';
import '../services/save_service.dart';
import 'story_screen.dart';

class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key, this.saveService});

  final SaveService? saveService;

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  CharacterType? _selectedCharacter;

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCharacter = _selectedCharacter;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EA),
      appBar: AppBar(
        title: const Text('Karakter Seçimi'),
        backgroundColor: const Color(0xFFF6F4EA),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minContentHeight = constraints.maxHeight > 40
                ? constraints.maxHeight - 40
                : 0.0;

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: constraints.maxHeight < 430,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minContentHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        selectedCharacter == null
                            ? 'Hikayeye hangi karakterle başlamak istersin?'
                            : 'Karakterinin adı ne olsun?',
                        style: const TextStyle(
                          color: Color(0xFF24322E),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (selectedCharacter == null)
                        SizedBox(
                          height: _characterGridHeight(constraints),
                          child: _CharacterGrid(onSelected: _selectCharacter),
                        )
                      else
                        _NameStep(
                          characterType: selectedCharacter,
                          controller: _nameController,
                          onBack: _changeCharacter,
                          onStart: () =>
                              _startStory(context, selectedCharacter),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _characterGridHeight(BoxConstraints constraints) {
    final baseHeight = constraints.maxHeight - 116;
    if (constraints.maxWidth > 620) {
      return baseHeight.clamp(176.0, 340.0).toDouble();
    }

    return baseHeight.clamp(360.0, 560.0).toDouble();
  }

  void _selectCharacter(CharacterType characterType) {
    setState(() {
      _selectedCharacter = characterType;
      _nameController.clear();
    });
  }

  void _changeCharacter() {
    setState(() {
      _selectedCharacter = null;
      _nameController.clear();
    });
  }

  void _startStory(BuildContext context, CharacterType characterType) {
    final enteredName = _nameController.text.trim();
    final heroName = enteredName.isEmpty
        ? characterType.defaultHeroName
        : enteredName;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => StoryScreen(
          characterType: characterType,
          heroName: heroName,
          friendName: characterType.defaultFriendName,
          saveService: widget.saveService,
        ),
      ),
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  const _CharacterGrid({required this.onSelected});

  final ValueChanged<CharacterType> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 620;
        final cards = CharacterType.values
            .map(
              (type) => _CharacterCard(
                characterType: type,
                onTap: () => onSelected(type),
              ),
            )
            .toList();

        if (isWide) {
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 16),
              Expanded(child: cards[1]),
            ],
          );
        }

        return Column(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(height: 16),
            Expanded(child: cards[1]),
          ],
        );
      },
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.characterType,
    required this.controller,
    required this.onBack,
    required this.onStart,
  });

  final CharacterType characterType;
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).height < 380;
    final padding = isCompact ? 16.0 : 24.0;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    characterType.label,
                    style: TextStyle(
                      color: const Color(0xFF24322E),
                      fontSize: isCompact ? 18 : 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Boş bırakırsan adı ${characterType.defaultHeroName} olur.',
                    style: const TextStyle(
                      color: Color(0xFF5D6762),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isCompact ? 12 : 18),
                  TextField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onStart(),
                    decoration: InputDecoration(
                      labelText: 'Karakter adı',
                      hintText: characterType.defaultHeroName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: isCompact ? 12 : 18),
                  FilledButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Hikayeye başla'),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isCompact ? 12 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onBack,
                    child: const Text('Karakteri değiştir'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({required this.characterType, required this.onTap});

  final CharacterType characterType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isGirl = characterType == CharacterType.girl;
    final colors = isGirl
        ? const [Color(0xFFE96D8C), Color(0xFFFFC3A0)]
        : const [Color(0xFF3F6FAE), Color(0xFF8FC7D8)];
    final icon = isGirl ? Icons.face_4_rounded : Icons.face_6_rounded;

    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final iconSize = constraints.biggest.shortestSide
                      .clamp(52.0, 96.0)
                      .toDouble();

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                    ),
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: iconSize),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      characterType.label,
                      style: const TextStyle(
                        color: Color(0xFF24322E),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
