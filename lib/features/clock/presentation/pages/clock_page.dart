import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_clock/features/clock/domain/usecases/add_player.dart';
import 'package:flutter_game_clock/features/clock/domain/usecases/remove_player.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/global_clock.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/nb_players.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/player_clock.dart';

class ClockPage extends StatelessWidget {
  final String title;
  ClockPage({this.title});

  @override
  Widget build(BuildContext context) {
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? true
            : false;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: Center(
        child: Flex(
          direction: _isPortrait ? Axis.vertical : Axis.horizontal,
          children: <Widget>[
            GlobalClock(),
            Spacer(),
            Center(child: PlayerClock()),
            Spacer(),
            Flex(
              direction: _isPortrait ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: NbPlayers(),
                ),
                Row(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
