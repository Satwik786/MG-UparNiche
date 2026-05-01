import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Color _bgColor = const Color.fromARGB(255, 0, 0, 0);

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

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

    HapticFeedback.lightImpact();

    setState(() {
      _bgColor = Colors.green;
    });

    _controller.markCorrect();
    _resetDetection();
  }

  void _handleSkip() {
    _canDetect = false;

    HapticFeedback.mediumImpact();

    setState(() {
      _bgColor = Colors.red;
    });

    _controller.skipWord();
    _resetDetection();
  }

  void _resetDetection() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _bgColor = const Color.fromARGB(255, 0, 0, 0);
      });
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _canDetect = true;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _controller.dispose();
    _sensorService.stopListening();
    _uiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameStarted) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              '$_countdown',
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    final GameState state = _controller.state;

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
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: double.infinity,
        color: _bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),

            Text(
              '${state.timeLeft}',
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),

            Expanded(
              child: Center(
                child: Text(
                  word,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Text(
              'Score: ${state.score}',
              style: const TextStyle(fontSize: 22, color: Colors.white70),
            ),

            const SizedBox(height: 20),

            const Text(
              'Tilt ↑ Correct | ↓ Skip',
              style: TextStyle(color: Colors.white54),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
