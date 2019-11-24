import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/domain/usecases/start_clock.dart';
import 'package:game_clock/features/clock/domain/usecases/stop_clock.dart';
import 'package:game_clock/features/clock/presentation/widget/clock.dart';

class ClockPage extends StatelessWidget {
  final String title;
  ClockPage({this.title});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Clock(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StartClockButton(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StopClockButton(),
                ),
              ],
            )

        ],),
      ),
    );
  }
}
