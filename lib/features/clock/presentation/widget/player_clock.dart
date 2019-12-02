import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/presentation/widget/player_timer.dart';

class PlayerClock extends StatelessWidget {
  const PlayerClock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
      child: Tooltip(
          message: 'Display active player number and its clock',
          child: PlayerTimer()),
    );
  }
}
