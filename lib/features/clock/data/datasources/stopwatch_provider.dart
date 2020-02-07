import 'package:flutter_game_clock/features/clock/data/datasources/stopwatch_stream.dart';
import 'package:rxdart/rxdart.dart';

/// Use to maintain state between hot restarts
/// Make sure you wrap this above the MaterialApp widget
/// or hot reload will affect it
class StopwatchProvider {
  StopwatchProvider({
    this.frequency = const Duration(seconds: 1),
  })  : _stopwatch = PersistedMyStopwatch(frequency: frequency),
        super() {
    _subject.addStream(_stopwatch.stream);

  }

  final Duration frequency;
  final PersistedMyStopwatch _stopwatch;

  final _subject = BehaviorSubject<Duration>();

  Stream<Duration> get stream => _subject.stream;
  Duration get elapsed => _subject.value;
  bool get state => _stopwatch.state;

  /// Reset the countdown
  void reset() => _stopwatch.reset();
  void start() => _stopwatch.start();
  void pause() => _stopwatch.pause();
  dispose() => _stopwatch.dispose();
}
