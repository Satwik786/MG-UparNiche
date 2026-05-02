import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../game/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  bool _showAnimation = false;

  Future<List<Category>>? _categoriesFuture;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(_textController);

    _scaleAnim = Tween<double>(
      begin: 0.9,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _categoriesFuture = CategoryService.fetchCategories();

    _startSequence();
  }

  void _startSequence() async {
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    setState(() {
      _showAnimation = true;
    });

    await Future.delayed(const Duration(milliseconds: 1700));

    if (!mounted) return;

    await _categoriesFuture;

    _navigate();
  }

  void _navigate() async {
    final categories = await _categoriesFuture ?? [];

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            HomeScreen(preloadedCategories: categories),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _showAnimation ? _buildAnimationScreen() : _buildCinematicText(),
    );
  }

  Widget _buildCinematicText() {
    return Center(
      child: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnim.value,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: const Text(
                "MUFT GAMES PRESENTS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimationScreen() {
    return Stack(
      children: [
        Center(
          child: Lottie.asset(
            'assets/animations/splash.json',
            fit: BoxFit.contain,
          ),
        ),
        Center(
          child: Text(
            "DAAYE BAAYE",
            style: TextStyle(
              color: Colors.white.withOpacity(0.18),
              fontSize: 42,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Text(
            "Made by SR",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
