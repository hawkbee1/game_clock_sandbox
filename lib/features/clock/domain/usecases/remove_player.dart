import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/entities/player.dart';
import 'package:game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:game_clock/injection_container.dart';

class RemovePlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerList _playerList = sl();
    ActivePlayer _activePlayer = sl();
    return FloatingActionButton(
      onPressed: () {
        debugPrint('length ${_playerList.players.length}');
        if(_activePlayer.player.playerId == _playerList.players.elementAt(_playerList.players.length-1).playerId) {
          _activePlayer.nextPlayer();
        }
        if(_playerList.players.length > 1) _playerList.removePlayer();
      },
      tooltip: 'Remove last player',
      child: IconButton(icon: Icon(Icons.remove), onPressed: null),);
  }
}
