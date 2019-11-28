import 'package:flutter/material.dart';
import 'package:game_clock/core/strings/widgets_keys.dart';
import 'package:game_clock/core/util/utils.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stopwatch = StopwatchProvider.of(context);

    return Container(
      key: Key(CLOCK),
      child: StreamBuilder<Duration>(
        stream: stopwatch.stream,
        builder: (context, snapshot) {
          return Text(
            prettyPrintDuration(snapshot.data),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60,
              color: Colors.black,
            ),
          );
        }
      ),
    );
  }
}
