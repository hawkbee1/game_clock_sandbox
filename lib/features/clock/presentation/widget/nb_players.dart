import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:game_clock/injection_container.dart';

class NbPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerList _playerList = sl();
    return StreamBuilder(
      stream: _playerList.nbPlayer,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Number of players: 0'),
        );
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Number of players: ${snapshot.data}'),
        );
      },

    );
  }
}
