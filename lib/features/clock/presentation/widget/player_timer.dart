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
    stream = _activePlayer.stream;
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
          stream = _activePlayer.stream;
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
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: tmp_Clock(stream: stream),
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
  }) : super(key: key);

  final Stream<Duration> stream;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        child: StreamBuilder<Duration>(
            stream: stream,
            builder: (context, snapshot) {
              final ActivePlayer _activePlayer = sl();
              if(!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                height: 200.0,
                key: Key(GLOBAL_TIMER),
                color: _activePlayer.player.color,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Player: ${_activePlayer.player.toString()}',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        prettyPrintDuration(snapshot.data),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
