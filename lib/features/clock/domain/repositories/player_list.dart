import 'package:flutter/cupertino.dart';
import 'package:game_clock/features/clock/domain/entities/player.dart';

class PlayerList {
  List<Player> _list = [];
  int _nbPlayers = 0;

  PlayerList() {
    addPlayer();
  }

  List<Player> get players => _list;

  addPlayer() {
    _nbPlayers++;
    Player _player = Player(playerId: _nbPlayers);
    debugPrint(_player.toString());
    _list.add(_player);
  }

}
