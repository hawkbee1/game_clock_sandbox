import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_clock/core/strings/widgets_keys.dart';
import 'package:game_clock/core/util/utils.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';
import 'package:game_clock/features/clock/domain/repositories/active_player_repository.dart';
import 'package:game_clock/injection_container.dart';

class PlayerTimer extends StatefulWidget {
  @override
  _PlayerTimerState createState() => _PlayerTimerState();
}

class _PlayerTimerState extends State<PlayerTimer> with TickerProviderStateMixin {
  ActivePlayer _activePlayer;
  StopwatchProvider _stopwatchProvider;
  Stream<Duration> stream;
  String player;
  AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _activePlayer = sl();
    _stopwatchProvider = sl();
    stream = _activePlayer.stream;
    player = _activePlayer.player;
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250), value: 1);
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
            stream = _activePlayer.stream;
            player = _activePlayer.player;
            if(_stopwatchProvider.state) _activePlayer.start();
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
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: tmp_Clock(stream: stream, player: player),
            ),
          );
        },
      ),
    );
  }
}

class tmp_Clock extends StatelessWidget {
  const tmp_Clock({
    Key key,
    @required this.stream,
    @required this.player,
    @required this.color,
  }) : super(key: key);

  final Stream<Duration> stream;
  final String player;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        height: 200.0,
        key: Key(GLOBAL_TIMER),
        color: color,
        child: Center(
          child: StreamBuilder<Duration>(
              stream: stream,
              builder: (context, snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Player: $player',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),),
                    Text(
                      prettyPrintDuration(snapshot.data),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
