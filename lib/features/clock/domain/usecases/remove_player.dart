import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/repositories/player_list.dart';
import 'package:game_clock/injection_container.dart';

class RemovePlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayerList playerList = sl();
    return FloatingActionButton(
      onPressed: () => playerList.removePlayer(),
      tooltip: 'Remove last player',
      child: IconButton(icon: Icon(Icons.remove), onPressed: null),);
  }
}
