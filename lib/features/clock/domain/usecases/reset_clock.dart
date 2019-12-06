import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:flutter_game_clock/injection_container.dart';

class ResetClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchProvider _stopwatchProvider = sl();
    final PlayerList _playerList = sl();
    return FloatingActionButton(
      tooltip: 'Reset all the clocks',
      onPressed: () {
        _stopwatchProvider.pause();
        _stopwatchProvider.reset();
        _playerList.reset();
      },
    child: Ink(
      decoration: ShapeDecoration(
        color: Colors.red,
        shape: CircleBorder(),
      ),
        child: IconButton(icon: Icon(Icons.stop), onPressed: null)),);
  }
}
