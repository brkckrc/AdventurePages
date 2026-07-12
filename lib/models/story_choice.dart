class StoryChoice {
  const StoryChoice({
    required this.text,
    required this.nextPageId,
    this.soundEffect,
  });

  final String text;
  final String nextPageId;
  final String? soundEffect;
}
