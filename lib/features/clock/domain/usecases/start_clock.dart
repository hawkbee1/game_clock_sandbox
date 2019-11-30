import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:game_clock/injection_container.dart';

class StartClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchProvider _stopwatchProvider = sl();
    final ActivePlayer _activePlayer = sl();
    return FloatingActionButton(
      onPressed: () {
        _stopwatchProvider.start();
            _activePlayer.start();
      },
      child: IconButton(icon: Icon(Icons.play_arrow), onPressed: null),);
  }
}
