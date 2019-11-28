import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';

class StartClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stopwatch = StopwatchProvider.of(context);
    return FloatingActionButton(
      onPressed: () => stopwatch.start(),
      child: IconButton(icon: Icon(Icons.play_arrow), onPressed: null),);
  }
}
