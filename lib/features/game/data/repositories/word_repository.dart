import '../models/word_model.dart';

class WordRepository {
  final Map<String, List<WordModel>> _words = {
    'general': [
      WordModel(text: 'Elephant', categoryId: 'general'),
      WordModel(text: 'Mobile Phone', categoryId: 'general'),
      WordModel(text: 'Cricket', categoryId: 'general'),
      WordModel(text: 'Teacher', categoryId: 'general'),
      WordModel(text: 'Train', categoryId: 'general'),
    ],
    'phrases': [
      WordModel(text: 'Arre yaar', categoryId: 'phrases'),
      WordModel(text: 'Kya kar raha hai', categoryId: 'phrases'),
      WordModel(text: 'Jugaad', categoryId: 'phrases'),
      WordModel(text: 'Chalta hai', categoryId: 'phrases'),
      WordModel(text: 'Bhai kya scene hai', categoryId: 'phrases'),
    ],
    'dialogues': [
      WordModel(text: 'Mogambo khush hua', categoryId: 'dialogues'),
      WordModel(text: 'Kitne aadmi the?', categoryId: 'dialogues'),
      WordModel(text: 'Pushpa, I hate tears', categoryId: 'dialogues'),
      WordModel(
        text: 'Don ko pakadna mushkil hi nahi, namumkin hai',
        categoryId: 'dialogues',
      ),
      WordModel(
        text: 'Picture abhi baaki hai mere dost',
        categoryId: 'dialogues',
      ),
    ],
  };

  List<WordModel> getWordsByCategory(String categoryId) {
    return _words[categoryId] ?? [];
  }
}
