import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/domain/usecases/add_player.dart';
import 'package:flutter_game_clock/features/clock/domain/usecases/remove_player.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/nb_players.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: NbPlayers(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RemovePlayerButton(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AddPlayerButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
