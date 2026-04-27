import 'package:flutter/material.dart';
import '../logic/game_state.dart';

class ResultScreen extends StatelessWidget {
  final GameState state;

  const ResultScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Score: ${state.score}', style: const TextStyle(fontSize: 32)),

            const SizedBox(height: 20),

            const Text('Correct Words'),
            ...state.correctWords.map((w) => Text('✅ ${w.text}')),

            const SizedBox(height: 20),

            const Text('Skipped Words'),
            ...state.skippedWords.map((w) => Text('❌ ${w.text}')),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
