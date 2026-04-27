import 'package:flutter/material.dart';
import 'game_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'id': 'general', 'name': 'General'},
      {'id': 'phrases', 'name': 'Indian Phrases'},
      {'id': 'dialogues', 'name': 'Movie Dialogues'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Category')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return ListTile(
            title: Text(category['name']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(categoryId: category['id']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
