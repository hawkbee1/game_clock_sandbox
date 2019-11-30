import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/presentation/widget/player_timer.dart';

class PlayerClock extends StatelessWidget {
  const PlayerClock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayerTimer();
  }
}
