import 'package:flutter/material.dart';
import 'package:flutter_game_clock/core/themes/styles.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:flutter_game_clock/injection_container.dart';

class NumberTurns extends StatelessWidget {
  const NumberTurns({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivePlayer _activePlayer = sl();
    return Tooltip(
        message: 'Display number of turns',
        child: Center(
          child: StreamBuilder(
            stream: _activePlayer.nbTurnsStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) return Text('Turn 0', style: bigTextStyle,);
              return Text('Turn ${snapshot.data}', style: bigTextStyle,);
            },
          ),
        ));
  }
}
