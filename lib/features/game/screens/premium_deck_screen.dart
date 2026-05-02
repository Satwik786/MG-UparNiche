import 'package:flutter/material.dart';
import 'game_screen.dart';

class PremiumDeckScreen extends StatelessWidget {
  const PremiumDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premiumCategories = [
      {"id": "hero_universe", "name": "Hero Universe"},
      {"id": "would_you_rather", "name": "Would You Rather?"},
      {"id": "truth_or_dare", "name": "Truth or Dare"},
      {"id": "funny_moments", "name": "Funny Moments"},
      {"id": "daily_soap_series", "name": "Daily Soap / Series"},
      {"id": "couple_goals", "name": "Couple Goals"},
      {"id": "rapid_fire", "name": "Rapid Fire"},
      {"id": "challenges", "name": "Challenges"},
      {"id": "never_have_i_ever", "name": "Never Have I Ever"},
      {"id": "random_crazy", "name": "Random & Crazy"},
      {"id": "pop_culture", "name": "Pop Culture"},
      {"id": "mystery_mode", "name": "Mystery Mode"},
    ];

    return Scaffold(
      body: Stack(
        children: [
          /// 🌄 Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/premiumbg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          /// 📱 Content
          SafeArea(
            child: Column(
              children: [
                /// 🔙 Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Premium Deck",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 227, 169, 10),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🧱 GRID
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: premiumCategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      final item = premiumCategories[index];

                      return _PremiumGridCard(
                        title: item["name"]!,
                        onTap: () {
                          /// 🔗 Connect to GameScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  GameScreen(categoryId: item["id"]!),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                /// 👑 CTA Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _GoPremiumButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🟪 GRID CARD
class _PremiumGridCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _PremiumGridCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 225, 163, 18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 242, 236, 236).withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 👑 BUTTON
class _GoPremiumButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromARGB(255, 241, 183, 25),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("In development , Enjoy with a working Prototype"),
            ),
          );
        },
        child: const Center(
          child: Text(
            "Coming Soon",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
