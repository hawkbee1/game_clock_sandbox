import 'package:flutter/material.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/features/clock/domain/usecases/start_clock.dart';
import 'package:game_clock/features/clock/domain/usecases/stop_clock.dart';
import 'package:game_clock/features/clock/presentation/widget/timer.dart';

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
            Clock(),
            Clock(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => addNewPlayer(),
          tooltip: 'Add a new player',
          child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addNewPlayer() {

  }
}

class Clock extends StatelessWidget {
  const Clock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StopwatchProvider(
      frequency: Duration(seconds: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Timer(),
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
          ),
      ],),
    );
  }
}
