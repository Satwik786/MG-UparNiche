import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/game/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const UparNicheApp());
}

class UparNicheApp extends StatelessWidget {
  const UparNicheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UparNiche',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
