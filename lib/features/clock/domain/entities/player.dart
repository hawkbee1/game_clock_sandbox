import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_clock/features/clock/data/datasources/stopwatch_provider.dart';

class Player extends Equatable {
  Player({@required this.playerId, @required this.color});
  final int playerId;
  final Color color;
  final StopwatchProvider _stopwatchProvider = StopwatchProvider();

  StopwatchProvider get stopwatch => _stopwatchProvider;

  String toString() => playerId.toString();

  @override
  // TODO: implement props
  List<Object> get props => [playerId];
}
