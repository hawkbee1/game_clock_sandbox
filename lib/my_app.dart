import 'package:flutter/material.dart';
import 'pages/game_page.dart';
import 'theme/app_theme.dart';

/// Root application widget.
/// Design Pattern: Composition Root — wires together theme, routing, and DI.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game Clock',
      theme: AppTheme.light,
      home: const GamePage(),
    );
  }
}
