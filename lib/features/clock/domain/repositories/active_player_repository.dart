import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/domain/entities/player.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:flutter_game_clock/injection_container.dart';

class ActivePlayer {
  ActivePlayer({this.playerList})
      : assert(playerList != null),
        _playerList = playerList,
        _activePlayer = playerList.players.elementAt(0) {
    _controllerActivePlayer.add(_activePlayer);
  }

  final PlayerList playerList;
  PlayerList _playerList;

  Player _activePlayer;
  int index = 0;
  int _nbTurns = 0;

  final _controllerActivePlayer = StreamController<Player>();
  final _controllerNbTurns = StreamController<int>();

  void nextPlayer() {
    _playerList = sl();
    debugPrint('nextPlayer tapped ${_playerList.players.length}');
    pause();
    // when we cycled through all players we start again at first player and add a turn
    if (index == _playerList.players.length - 1) {
      _activePlayer = _playerList.players.elementAt(0);
      _nbTurns++;
      _controllerNbTurns.add(_nbTurns);
      index = 0;
    } else {
      index++;
      _activePlayer = _playerList.players.elementAt(index);
    }
    _controllerActivePlayer.add(_activePlayer);
  }

  void start() {
    _activePlayer.stopwatch.start();
  }

  void pause() {
    _activePlayer.stopwatch.pause();
  }

  void gameReset() {
    _nbTurns = 0;
    _controllerNbTurns.add(_nbTurns);
  }

  Stream<Duration> get timeStream => _activePlayer.stopwatch.stream;

  Stream<Player> get playerStream => _controllerActivePlayer.stream;

  Stream<int> get nbTurnsStream => _controllerNbTurns.stream;

  Player get activePlayer => _activePlayer;
}
