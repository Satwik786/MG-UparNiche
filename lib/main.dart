import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/game/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const DaayeBaayeApp());
}

class DaayeBaayeApp extends StatelessWidget {
  const DaayeBaayeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaayeBaaye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(),
    );
  }
}
