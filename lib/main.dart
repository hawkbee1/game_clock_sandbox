import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/presentation/pages/clock_page.dart';

import 'plugins/desktop/desktop.dart';

void main() {
  setTargetPlatformForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockPage(title: 'Clock for your games'),
    );
  }
}

