import 'dart:async';

import 'package:game_clock/features/clock/data/datasources/persistence.dart';


class MyStopwatchTimer {
  MyStopwatchTimer({
        this.frequency = const Duration(seconds: 1),
      }) {
    _init();
  }

  final Duration frequency;
  final _controller = StreamController<Duration>();

  Duration _elapsed;
  Duration get elapsed => _elapsed;
  Stream<Duration> get stream => _controller.stream;

  void reset() => _elapsed = Duration();

  _init() {
    _elapsed = Duration();
    Timer.periodic(frequency, (t) {
      _controller.add(_elapsed);
      _elapsed += frequency;
    });
  }
}

class MyStopwatch {
  MyStopwatch({
        this.frequency = const Duration(seconds: 1),
      });

  final Duration frequency;

  Duration _elapsed;
  Duration get remaining => _elapsed;

  Stream<Duration> get stream async* {
    _elapsed = Duration();
      yield _elapsed;
      _elapsed += frequency;
      await Future.delayed(frequency);
  }
}

class PersistedMyStopwatch {
  PersistedMyStopwatch(
      {
        Duration frequency = const Duration(seconds: 1),
      }) {
    _init(frequency);
  }

  _init(Duration frequency) async {
    _stopwatch = MyStopwatchTimer(frequency: frequency);
    // Add the countdown stream to the controller and delete cache when finished
    _controller.addStream(_stopwatch.stream).then((_) => deleteDuration());
    // Persist the countdown
    stream.listen(saveDuration);
  }

  final _controller = StreamController<Duration>.broadcast();
  MyStopwatchTimer _stopwatch;

  Stream<Duration> get stream => _controller.stream;
  Duration get elapsed => _stopwatch.elapsed;

  void reset() => _stopwatch.reset();

  dispose() => _controller?.close();
}
