enum CharacterType {
  girl,
  boy;

  String get label {
    switch (this) {
      case CharacterType.girl:
        return 'Kız karakter';
      case CharacterType.boy:
        return 'Erkek karakter';
    }
  }

  String get shortLabel {
    switch (this) {
      case CharacterType.girl:
        return 'Kız';
      case CharacterType.boy:
        return 'Erkek';
    }
  }

  String get defaultHeroName {
    switch (this) {
      case CharacterType.girl:
        return 'Mina';
      case CharacterType.boy:
        return 'Aras';
    }
  }

  String get defaultFriendName {
    switch (this) {
      case CharacterType.girl:
        return 'Aras';
      case CharacterType.boy:
        return 'Mina';
    }
  }
}
