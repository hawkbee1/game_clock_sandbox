import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_clock/features/clock/domain/usecases/add_player.dart';
import 'package:flutter_game_clock/features/clock/domain/usecases/remove_player.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/global_clock.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/nb_players.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/player_clock.dart';

class ClockPage extends StatelessWidget {
  ClockPage();

  @override
  Widget build(BuildContext context) {
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? true
            : false;
    return Scaffold(
      body: Center(
        child: Flex(
          direction: _isPortrait ? Axis.vertical : Axis.horizontal,
          children: <Widget>[
            Spacer(),
            GlobalClock(),
            Center(child: PlayerClock()),
            Spacer(),
            Flex(
              direction: _isPortrait ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
