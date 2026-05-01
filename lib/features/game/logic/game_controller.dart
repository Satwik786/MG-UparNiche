import 'dart:async';
import '../data/repositories/word_repository.dart';
import '../data/models/word_model.dart';
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

  /// START GAME (NOW ASYNC)
  Future<void> startGame(String categoryId) async {
    await _repository.loadWords();

    final words = List<WordModel>.from(
      _repository.getWordsByCategory(categoryId),
    )..shuffle();

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

  /// Prevent running out of words
  void _ensureMoreWords() {
    if (_state.currentIndex >= _state.words.length - 1) {
      final moreWords = List<WordModel>.from(_state.words)..shuffle();

      _state = _state.copyWith(words: [..._state.words, ...moreWords]);
    }
  }

  void markCorrect() {
    _ensureMoreWords();

    final word = _state.currentWord;

    _state = _state.copyWith(
      score: _state.score + 1,
      currentIndex: _state.currentIndex + 1,
      correctWords: [..._state.correctWords, if (word != null) word],
    );
  }

  void skipWord() {
    _ensureMoreWords();

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
