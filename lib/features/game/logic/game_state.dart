import '../data/models/word_model.dart';

class GameState {
  final List<WordModel> words;
  final int currentIndex;
  final int score;
  final int timeLeft;
  final bool isGameOver;

  final List<WordModel> correctWords;
  final List<WordModel> skippedWords;

  const GameState({
    required this.words,
    required this.currentIndex,
    required this.score,
    required this.timeLeft,
    required this.isGameOver,
    required this.correctWords,
    required this.skippedWords,
  });

  WordModel? get currentWord {
    if (currentIndex < words.length) {
      return words[currentIndex];
    }
    return null;
  }

  GameState copyWith({
    List<WordModel>? words,
    int? currentIndex,
    int? score,
    int? timeLeft,
    bool? isGameOver,
    List<WordModel>? correctWords,
    List<WordModel>? skippedWords,
  }) {
    return GameState(
      words: words ?? this.words,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isGameOver: isGameOver ?? this.isGameOver,
      correctWords: correctWords ?? this.correctWords,
      skippedWords: skippedWords ?? this.skippedWords,
    );
  }
}
