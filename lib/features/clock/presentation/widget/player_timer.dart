import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_game_clock/core/strings/widgets_keys.dart';
import 'package:flutter_game_clock/core/themes/styles.dart';
import 'package:flutter_game_clock/core/util/utils.dart';
import 'package:flutter_game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:flutter_game_clock/features/clock/domain/entities/player.dart';
import 'package:flutter_game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:flutter_game_clock/injection_container.dart';

class PlayerTimer extends StatefulWidget {
  @override
  _PlayerTimerState createState() => _PlayerTimerState();
}

class _PlayerTimerState extends State<PlayerTimer>
    with TickerProviderStateMixin {
  ActivePlayer _activePlayer;
  StopwatchProvider _stopwatchProvider;
  Stream<Duration> stream;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _activePlayer = sl();
    _stopwatchProvider = sl();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 125), value: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        setState(() {
          _activePlayer.nextPlayer();
          if (_stopwatchProvider.state) _activePlayer.start();
        });
        await _controller.forward();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationX((1 - _controller.value) * pi / 2),
            alignment: Alignment.center,
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(9, 9),
                      blurRadius: 10,
                      spreadRadius: 5.0,
                    )
                  ],
                ),
              margin: EdgeInsets.symmetric(horizontal: 20),
//              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: PlayerClockPanel(),
            ),
          );
        },
      ),
    );
  }
}

class PlayerClockPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ActivePlayer _activePlayer = sl();
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        child: StreamBuilder<Player>(
            stream: _activePlayer.playerStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                height: 200.0,
                key: Key(GLOBAL_TIMER),
                decoration: BoxDecoration(
                  gradient: LinearGradient(

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:[
                        snapshot.data.color,
                        snapshot.data.color,
                        snapshot.data.color,
                        Colors.blue,
                      ])
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Player: ${snapshot.data.toString()}',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                      PlayerStopWatch(),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class PlayerStopWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ActivePlayer _activePlayer = sl();
    return StreamBuilder<Duration>(
        stream: _activePlayer.timeStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Text(
            prettyPrintDuration(snapshot.data),
            style: bigTextStyle,
          );
        });
  }
}
