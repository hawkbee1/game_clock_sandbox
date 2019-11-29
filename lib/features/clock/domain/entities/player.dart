import 'package:equatable/equatable.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_provider.dart';

class Player extends Equatable {
  Player({this.playerId});
  final int playerId;
  final StopwatchProvider _stopwatchProvider = StopwatchProvider();

  StopwatchProvider get stopwatch => _stopwatchProvider;

  String toString() => playerId.toString();

  @override
  // TODO: implement props
  List<Object> get props => [playerId];
}