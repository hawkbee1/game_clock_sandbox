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

  Timer _timer;
  Duration _elapsed;
  Duration get elapsed => _elapsed;
  Stream<Duration> get stream => _controller.stream;
//  _state false means stopwatch is stopped and true means stopwatch is running
  bool _state = false;
  bool get state => _state;

  void reset() {
    pause();
    _elapsed = Duration();
    _state = false;
  }

  _init() {
    _elapsed = Duration(seconds: 0);
    _timer = Timer.periodic(frequency, (t)
    {
      _controller.add(_elapsed);
    });
  }

  void createTimer() {
    _timer = Timer.periodic(frequency, (t) {
      _controller.add(_elapsed);
      _elapsed += frequency;
    });
  }

  pause() {
//    need just to dispose the timer... I think
  _timer.cancel();
  _state  = false;
  }

  start() {
    _timer.cancel();
    createTimer();
    _state = true;
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

  bool get state => _stopwatch.state;

  void reset() => _stopwatch.reset();

  void pause() => _stopwatch.pause();

  void start() => _stopwatch.start();

  dispose() => _controller?.close();
}
