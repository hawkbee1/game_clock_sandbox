import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/injection_container.dart';

class StopClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchProvider stopwatchProvider = sl();
    return FloatingActionButton(
      onPressed: () => stopwatchProvider.stop(),
    child: IconButton(icon: Icon(Icons.stop), onPressed: null),);
  }
}
