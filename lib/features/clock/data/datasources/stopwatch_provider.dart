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

    _minuteSubject.addStream(
        _stopwatch.stream.where((Duration d) => d.inSeconds % 60 == 0));
    _tensMinuteDigitSubject
        .addStream(_stopwatch.stream.map<int>((d) => d.inMinutes ~/ 10));
    _onesMinuteDigitSubject
        .addStream(_stopwatch.stream.map<int>((d) => d.inMinutes % 10));
    _tensSecondDigitSubject
        .addStream(_stopwatch.stream.map<int>((d) => (d.inSeconds % 60) ~/ 10));
    _onesSecondDigitSubject
        .addStream(_stopwatch.stream.map<int>((d) => (d.inSeconds % 60) % 10));
  }

  final Duration frequency;
  final PersistedMyStopwatch _stopwatch;

  final _subject = BehaviorSubject<Duration>();
  final _minuteSubject = BehaviorSubject<Duration>();
  final _tensMinuteDigitSubject = BehaviorSubject<int>();
  final _onesMinuteDigitSubject = BehaviorSubject<int>();
  final _tensSecondDigitSubject = BehaviorSubject<int>();
  final _onesSecondDigitSubject = BehaviorSubject<int>();

  Stream<Duration> get stream => _subject.stream;
  Duration get elapsed => _subject.value;

  Stream<Duration> get minuteStream => _minuteSubject.stream;

  Stream<int> get tensMinuteDigitStream => _tensMinuteDigitSubject.stream;
  Stream<int> get onesMinuteDigitStream => _onesMinuteDigitSubject.stream;
  Stream<int> get tensSecondDigitStream => _tensSecondDigitSubject.stream;
  Stream<int> get onesSecondDigitStream => _onesSecondDigitSubject.stream;

  int get tensMinuteDigit => _tensMinuteDigitSubject.value ?? 0;
  int get onesMinuteDigit => _onesMinuteDigitSubject.value ?? 0;
  int get tensSecondDigit => _tensSecondDigitSubject.value ?? 0;
  int get onesSecondDigit => _tensSecondDigitSubject.value ?? 0;

  static StopwatchProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(StopwatchProvider);

  @override
  bool updateShouldNotify(InheritedWidget _) => false;

  /// Reset the countdown
  void reset() => _stopwatch.reset();
}
