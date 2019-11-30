import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:game_clock/injection_container.dart';

class ResetClockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchProvider _stopwatchProvider = sl();
    final PlayerList _playerList = sl();
    return FloatingActionButton(
      onPressed: () {
        _stopwatchProvider.reset();
        _playerList.reset();
      },
    child: IconButton(icon: Icon(Icons.stop), onPressed: null),);
  }
}
