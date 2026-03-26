import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/game_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game Clock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
            fontSize: 36,
            color: Colors.black87,
          ),
          bodyMedium: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
      home: const GamePage(),
    );
  }
}
