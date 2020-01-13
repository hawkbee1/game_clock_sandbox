import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/presentation/pages/clock_page.dart';
import 'package:flutter_game_clock/injection_container.dart' as di;
import 'plugins/desktop/desktop.dart';


void main() async {
  setTargetPlatformForDesktop();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _defaultGameClockTheme,
      home: ClockPage(),
    );
  }
}


final ThemeData _defaultGameClockTheme = _buildDefaultTheme();

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    buttonTheme: base.buttonTheme.copyWith(
      textTheme: ButtonTextTheme.normal,
    ),
  );
}
