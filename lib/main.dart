import 'package:flutter/material.dart';
import 'features/game/screens/home_screen.dart';

void main() {
  runApp(const UparNicheApp());
}

class UparNicheApp extends StatelessWidget {
  const UparNicheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UparNiche',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),

      home: const HomeScreen(),
    );
  }
}
