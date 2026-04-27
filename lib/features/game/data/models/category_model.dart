class CategoryModel {
  final String id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name)';
  }
}
