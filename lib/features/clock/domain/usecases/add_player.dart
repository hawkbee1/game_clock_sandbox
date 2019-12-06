import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:flutter_game_clock/injection_container.dart';

class AddPlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerList playerList = sl();
    return FloatingActionButton(
      onPressed: () => playerList.addPlayer(),
      tooltip: 'Add a new player',
      child: IconButton(icon: Icon(Icons.add), onPressed: null),);
  }
}
