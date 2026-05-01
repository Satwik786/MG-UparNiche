import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word_model.dart';

class WordRepository {
  Map<String, List<WordModel>> _words = {};

  bool _isLoaded = false;

  /// Load words from JSON (only once)
  Future<void> loadWords() async {
    if (_isLoaded) return;

    final jsonString = await rootBundle.loadString('assets/data/words.json');

    final Map<String, dynamic> data = json.decode(jsonString);

    _words = data.map((categoryId, wordsList) {
      final list = (wordsList as List)
          .map((word) => WordModel(text: word, categoryId: categoryId))
          .toList();

      return MapEntry(categoryId, list);
    });

    _isLoaded = true;
  }

  /// Get words for category
  List<WordModel> getWordsByCategory(String categoryId) {
    return _words[categoryId] ?? [];
  }
}
