import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/usecases/add_player.dart';
import 'package:game_clock/features/clock/presentation/widget/global_clock.dart';
import 'package:game_clock/features/clock/presentation/widget/player_clock.dart';

class ClockPage extends StatelessWidget {
  final String title;
  ClockPage({this.title});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Center(

        child: Column(
          children: <Widget>[
            GlobalClock(),
            PlayerClock(),
            Container(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
              child: Text('we\'ll see'),),
            )
          ],
        ),
      ),
      floatingActionButton: AddPlayerButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addNewPlayer() {

  }
}

