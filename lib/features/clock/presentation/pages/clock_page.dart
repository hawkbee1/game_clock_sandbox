import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/global_clock.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/player_clock.dart';
import 'package:flutter_game_clock/features/clock/presentation/widget/players_list.dart';

class ClockPage extends StatelessWidget {
  ClockPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Spacer(),
              PlayersList(),
              Spacer(),
              Center(child: PlayerClock()),
              Spacer(),
              GlobalClock(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}