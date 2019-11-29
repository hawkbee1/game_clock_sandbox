import 'package:flutter/cupertino.dart';
import 'package:game_clock/features/clock/domain/entities/player.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:game_clock/injection_container.dart';

class ActivePlayer {
  ActivePlayer({this.playerList}): 
      assert(playerList != null),
        _playerList = playerList,
  _activePlayer = playerList.players.elementAt(0);

  final PlayerList playerList;
  PlayerList _playerList;
  
  Player _activePlayer;
  int index = 0;

  void nextPlayer() {
    _playerList = sl();
    debugPrint('nextPlayer tapped ${_playerList.players.length}');
    stop();
    if(index == _playerList.players.length - 1) {
      debugPrint('first');

      _activePlayer = _playerList.players.elementAt(0);
      index = 0;
    } else {
      debugPrint('second');
      index++;
      _activePlayer = _playerList.players.elementAt(index);
    }
    start();
  }

  void start() {
    _activePlayer.stopwatch.start();
  }

  void stop() {
    _activePlayer.stopwatch.stop();
  }

  Stream<Duration> get stream => _activePlayer.stopwatch.stream;

}