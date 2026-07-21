enum CharacterPose { idle, thinking, surprised, pointing }

class CharacterReaction {
  const CharacterReaction({required this.text, required this.pose});

  final String text;
  final CharacterPose pose;
}
