import 'package:flutter/material.dart';
import 'package:game_clock/core/strings/widgets_keys.dart';
import 'package:game_clock/core/util/utils.dart';
import 'package:game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:game_clock/injection_container.dart';

class PlayerTimer extends StatefulWidget {
  @override
  _PlayerTimerState createState() => _PlayerTimerState();
}

class _PlayerTimerState extends State<PlayerTimer> {
  ActivePlayer activePlayer;
  Stream<Duration> stream;

  @override
  void initState() {
    // TODO: implement initState
    activePlayer = sl();
    stream = activePlayer.stream;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        setState(() {
          activePlayer.nextPlayer();
          stream = activePlayer.stream;
        });
      },
      child: Container(
        key: Key(GLOBAL_TIMER),
        child: StreamBuilder<Duration>(
          stream: stream,
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
      ),
    );
  }
}
