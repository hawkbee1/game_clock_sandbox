import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/entities/player.dart';

class PlayerList {
  List<Player> _list = [];
  int _nbPlayers = 0;
  final _controller = StreamController<int>.broadcast();

  PlayerList() {
    _controller.add(_nbPlayers);
    addPlayer();
  }

  List<Player> get players => _list;
  Stream<int> get nbPlayer => _controller.stream;

  addPlayer() {
    _nbPlayers++;
    Player _player = Player(playerId: _nbPlayers);
    debugPrint(_player.toString());
    _list.add(_player);
    _controller.add(_nbPlayers);

  }

  reset() {
    _list.map((player) => player.stopwatch.reset());
  }
}
