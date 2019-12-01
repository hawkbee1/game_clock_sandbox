import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_clock/features/clock/domain/usecases/add_player.dart';
import 'package:game_clock/features/clock/presentation/widget/global_clock.dart';
import 'package:game_clock/features/clock/presentation/widget/nb_players.dart';
import 'package:game_clock/features/clock/presentation/widget/player_clock.dart';

class ClockPage extends StatelessWidget {
  final String title;
  ClockPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Transform.scale(scale: 0.7, child: GlobalClock()),
            Spacer(),
            PlayerClock(),
            Spacer(),
            Container(
              child: NbPlayers(),
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton:
          AddPlayerButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
