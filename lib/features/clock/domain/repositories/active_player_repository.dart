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
    _controller.add(_activePlayer);
  }

  final PlayerList playerList;
  PlayerList _playerList;

  Player _activePlayer;
  int index = 0;
  final _controller = StreamController<Player>();

  void nextPlayer() {
    _playerList = sl();
    debugPrint('nextPlayer tapped ${_playerList.players.length}');
    pause();
    if (index == _playerList.players.length - 1) {
      debugPrint('first');

      _activePlayer = _playerList.players.elementAt(0);
      index = 0;
    } else {
      debugPrint('second');
      index++;
      _activePlayer = _playerList.players.elementAt(index);
    }
    _controller.add(_activePlayer);
  }

  void start() {
    _activePlayer.stopwatch.start();
  }

  void pause() {
    _activePlayer.stopwatch.pause();
  }

  Stream<Duration> get timeStream => _activePlayer.stopwatch.stream;

  Stream<Player> get playerStream => _controller.stream;
  
  Player get activePlayer => _activePlayer;
}
