import 'package:flutter/widgets.dart';
import 'package:game_clock/features/clock/data/datasources/stopwatch_stream.dart';
import 'package:rxdart/rxdart.dart';

/// Use to maintain state between hot restarts
/// Make sure you wrap this above the MaterialApp widget
/// or hot reload will affect it
class StopwatchProvider extends InheritedWidget {
  StopwatchProvider({
    Key key,
    @required Widget child,
    this.frequency = const Duration(seconds: 1),
  })  : assert(child != null),
        _stopwatch = PersistedMyStopwatch(frequency: frequency),
        super(key: key, child: child) {
    _subject.addStream(_stopwatch.stream);

  }

  final Duration frequency;
  final PersistedMyStopwatch _stopwatch;

  final _subject = BehaviorSubject<Duration>();

  Stream<Duration> get stream => _subject.stream;
  Duration get elapsed => _subject.value;

  static StopwatchProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(StopwatchProvider);

  @override
  bool updateShouldNotify(InheritedWidget _) => false;

  /// Reset the countdown
  void reset() => _stopwatch.reset();
  void start() => _stopwatch.start();
  void stop() => _stopwatch.stop();
}
