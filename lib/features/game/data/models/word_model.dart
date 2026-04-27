class WordModel {
  final String text;
  final String categoryId;

  const WordModel({required this.text, required this.categoryId});

  @override
  String toString() {
    return 'WordModel(text: $text, categoryId: $categoryId)';
  }
}
