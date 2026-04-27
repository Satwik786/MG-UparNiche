import 'dart:async';
import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../data/repositories/word_repository.dart';
import '../logic/game_state.dart';
import 'result_screen.dart';
import '../../../shared/services/sensor_service.dart';

class GameScreen extends StatefulWidget {
  final String categoryId;

  const GameScreen({super.key, required this.categoryId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;
  late SensorService _sensorService;

  Timer? _uiTimer;

  bool _canDetect = true;

  int _countdown = 3;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();

    _controller = GameController(WordRepository());
    _sensorService = SensorService();

    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();

        setState(() {
          _gameStarted = true;
        });

        _startGame();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _startGame() {
    _controller.startGame(widget.categoryId);

    _uiTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() {});
    });

    _sensorService.startListening((direction) {
      if (!_canDetect) return;

      if (direction == TiltDirection.up) {
        _handleCorrect();
      } else if (direction == TiltDirection.down) {
        _handleSkip();
      }
    });
  }

  void _handleCorrect() {
    _canDetect = false;
    _controller.markCorrect();
    _resetDetection();
  }

  void _handleSkip() {
    _canDetect = false;
    _controller.skipWord();
    _resetDetection();
  }

  void _resetDetection() {
    Future.delayed(const Duration(milliseconds: 800), () {
      _canDetect = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sensorService.stopListening();
    _uiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Countdown UI
    if (!_gameStarted) {
      return Scaffold(
        body: Center(
          child: Text(
            '$_countdown',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final GameState state = _controller.state;

    // 🔥 Navigate to result screen
    if (state.isGameOver) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(state: state)),
        );
      });

      return const SizedBox();
    }

    final word = state.currentWord?.text ?? 'No Words';

    return Scaffold(
      appBar: AppBar(title: const Text('UparNiche')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Timer
          Text('Time: ${state.timeLeft}', style: const TextStyle(fontSize: 24)),

          const SizedBox(height: 40),

          // Word
          Text(
            word,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          // Score
          Text('Score: ${state.score}', style: const TextStyle(fontSize: 24)),

          const SizedBox(height: 20),

          const Text(
            'Tilt Up = Correct ✅\nTilt Down = Skip ❌',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
