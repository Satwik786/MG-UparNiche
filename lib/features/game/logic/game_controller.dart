import 'dart:async';
import '../data/repositories/word_repository.dart';
import 'game_state.dart';

class GameController {
  final WordRepository _repository;

  GameState _state = const GameState(
    words: [],
    currentIndex: 0,
    score: 0,
    timeLeft: 60,
    isGameOver: false,
    correctWords: [],
    skippedWords: [],
  );

  GameState get state => _state;

  Timer? _timer;

  GameController(this._repository);

  void startGame(String categoryId) {
    final words = _repository.getWordsByCategory(categoryId)..shuffle();

    _state = GameState(
      words: words,
      currentIndex: 0,
      score: 0,
      timeLeft: 60,
      isGameOver: false,
      correctWords: [],
      skippedWords: [],
    );

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.timeLeft <= 1) {
        _state = _state.copyWith(timeLeft: 0, isGameOver: true);
        timer.cancel();
      } else {
        _state = _state.copyWith(timeLeft: _state.timeLeft - 1);
      }
    });
  }

  void markCorrect() {
    final word = _state.currentWord;

    _state = _state.copyWith(
      score: _state.score + 1,
      currentIndex: _state.currentIndex + 1,
      correctWords: [..._state.correctWords, if (word != null) word],
    );
  }

  void skipWord() {
    final word = _state.currentWord;

    _state = _state.copyWith(
      currentIndex: _state.currentIndex + 1,
      skippedWords: [..._state.skippedWords, if (word != null) word],
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
