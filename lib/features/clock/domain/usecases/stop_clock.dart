import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';

class StopClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stopwatch = StopwatchProvider.of(context);
    return FloatingActionButton(
      onPressed: () => stopwatch.reset(),
    child: IconButton(icon: Icon(Icons.stop), onPressed: null),);
  }
}
