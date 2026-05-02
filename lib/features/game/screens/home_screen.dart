import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'game_screen.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final String rules;
  final String image;
  final String bgImage;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.rules,
    required this.image,
    required this.bgImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rules: json['rules'] ?? '',
      image: json['image'] ?? 'assets/images/default.png',
      bgImage: json['bgImage'] ?? 'assets/images/default_bg.png',
    );
  }
}

class CategoryService {
  static const String _url = 'https://your-api.com/categories';

  static Future<List<Category>> fetchCategories() async {
    try {
      final res = await http.get(Uri.parse(_url));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return (data as List).map((e) => Category.fromJson(e)).toList();
      } else {
        throw Exception();
      }
    } catch (_) {
      return _fallback;
    }
  }

  static const _fallback = [
    Category(
      id: 'general',
      name: 'General',
      description: 'Guess common everyday words and objects.',
      rules: 'Tilt Right → Correct \nTilt Left → Skip ',
      image: 'assets/images/general.png',
      bgImage: 'assets/images/generalbg.png',
    ),
    Category(
      id: 'phrases',
      name: 'Indian Phrases',
      description: 'Act out popular Indian phrases and slang.',
      rules: 'Tilt Right → Correct \nTilt Left → Skip ',
      image: 'assets/images/indian.png',
      bgImage: 'assets/images/indianbg.png',
    ),
    Category(
      id: 'dialogues',
      name: 'Movie Dialogues',
      description: 'Guess famous movie dialogues.',
      rules: 'Tilt Right → Correct \nTilt Left → Skip ',
      image: 'assets/images/movie.png',
      bgImage: 'assets/images/moviebg.png',
    ),
  ];
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _controller;
  double _page = 1000;

  @override
  void initState() {
    super.initState();

    _controller = PageController(viewportFraction: 0.7, initialPage: 1000);

    _controller.addListener(() {
      setState(() {
        _page = _controller.page ?? 1000;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Category>>(
        future: CategoryService.fetchCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;
          final index = _page.round() % categories.length;
          final currentCategory = categories[index];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(currentCategory.bgImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'DaayeBaaye',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: CategoryDeck(
                        categories: categories,
                        controller: _controller,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryDeck extends StatelessWidget {
  final List<Category> categories;
  final PageController controller;

  const CategoryDeck({
    super.key,
    required this.categories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemBuilder: (context, index) {
        final category = categories[index % categories.length];

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            double scale = 1.0;

            if (controller.position.haveDimensions) {
              scale = controller.page! - index;
              scale = (1 - (scale.abs() * 0.2)).clamp(0.85, 1.0);
            }

            return Center(
              child: Transform.scale(
                scale: scale,
                child: CategoryCard(category: category),
              ),
            );
          },
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        width: 180,
        height: 310,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: AssetImage(category.image),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 250),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: _expandedCard(context),
          ),
        );
      },
    );
  }

  Widget _expandedCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(category.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black.withOpacity(0.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              category.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              category.rules,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(categoryId: category.id),
                  ),
                );
              },
              child: const Text('PLAY'),
            ),
          ],
        ),
      ),
    );
  }
}
