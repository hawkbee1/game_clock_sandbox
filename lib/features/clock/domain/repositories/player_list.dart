import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/domain/entities/player.dart';

class PlayerList {
  List<Player> _list = [];
  int _nbPlayers = 0;
  final _controller = StreamController<int>();
  static const List<Color> colorList = [
    Colors.brown,
    Colors.green,
    Colors.deepOrange,
    Colors.tealAccent,
    Colors.yellowAccent,
    Colors.redAccent,
    Colors.deepPurple,
    Colors.limeAccent,
    Colors.lightBlueAccent,
    Colors.pinkAccent,
  ];

  PlayerList() {
    _controller.add(_nbPlayers);
    addPlayer();
    debugPrint(_nbPlayers.toString());
  }

  List<Player> get players => _list;
  Stream<int> get nbPlayer => _controller.stream;

  addPlayer() {
    _nbPlayers++;
    Color _color = colorList.elementAt((_nbPlayers % 10));
    Player _player = Player(playerId: _nbPlayers, color: _color);
    _list.add(_player);
    _controller.add(_nbPlayers);
  }

  removePlayer() {
    _list.removeLast();
    _nbPlayers--;
    _controller.add(_nbPlayers);
  }

  reset() {
    _list.forEach((_player) {
      _player.stopwatch.pause();
      _player.stopwatch.reset();
    });
  }
}
