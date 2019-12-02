import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:game_clock/injection_container.dart';

class StopClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchProvider _stopwatchProvider = sl();
    final ActivePlayer _activePlayer = sl();
    return FloatingActionButton(
      tooltip: 'Pause all clocks',
      onPressed: () {
        _stopwatchProvider.pause();
        _activePlayer.pause();
      },
    child: IconButton(icon: Icon(Icons.pause), onPressed: null),);
  }
}
