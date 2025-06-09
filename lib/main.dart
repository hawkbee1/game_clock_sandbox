import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Clock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GameClockPage(),
    );
  }
}

class GameClockPage extends StatefulWidget {
  const GameClockPage({super.key});

  @override
  State<GameClockPage> createState() => _GameClockPageState();
}

class _GameClockPageState extends State<GameClockPage> {
  final List<Stopwatch> _playerStopwatches = [];
  final Stopwatch _gameStopwatch = Stopwatch();
  Timer? _timer;
  int _currentPlayerIndex = 0;
  int _numberOfPlayers = 5;
  bool _isGameRunning = false;

  @override
  void initState() {
    super.initState();
    _initializeStopwatches();
    _startTimer();
  }

  void _initializeStopwatches() {
    _playerStopwatches.clear();
    for (int i = 0; i < _numberOfPlayers; i++) {
      _playerStopwatches.add(Stopwatch());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (mounted) setState(() {});
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String centiseconds = twoDigits(
      duration.inMilliseconds.remainder(1000) ~/ 10,
    );
    return "$minutes:$seconds:$centiseconds";
  }

  void _startGame() {
    setState(() {
      _isGameRunning = true;
      _gameStopwatch.start();
      _playerStopwatches[_currentPlayerIndex].start();
    });
  }

  void _pauseGame() {
    setState(() {
      _isGameRunning = false;
      _gameStopwatch.stop();
      _playerStopwatches[_currentPlayerIndex].stop();
    });
  }

  void _resetGame() {
    setState(() {
      _isGameRunning = false;
      _gameStopwatch.stop();
      _gameStopwatch.reset();
      for (var stopwatch in _playerStopwatches) {
        stopwatch.stop();
        stopwatch.reset();
      }
      _currentPlayerIndex = 0;
    });
  }

  void _nextPlayer() {
    if (!_isGameRunning) return;
    setState(() {
      _playerStopwatches[_currentPlayerIndex].stop();
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _numberOfPlayers;
      _playerStopwatches[_currentPlayerIndex].start();
    });
  }

  void _addPlayer() {
    if (_numberOfPlayers < 10) {
      setState(() {
        _numberOfPlayers++;
        _playerStopwatches.add(Stopwatch());
      });
    }
  }

  void _removePlayer() {
    if (_numberOfPlayers > 2) {
      setState(() {
        _numberOfPlayers--;
        _playerStopwatches.removeLast();
        if (_currentPlayerIndex >= _numberOfPlayers) {
          _currentPlayerIndex = _numberOfPlayers - 1;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Clock for your games',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Game stopwatch
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(_gameStopwatch.elapsed),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isGameRunning ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: _isGameRunning ? _pauseGame : _startGame,
                            color: Colors.blue,
                            iconSize: 48,
                          ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: _resetGame,
                            color: Colors.red,
                            iconSize: 48,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Player display
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: _nextPlayer,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Player: ${_currentPlayerIndex + 1}',
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDuration(
                              _playerStopwatches[_currentPlayerIndex].elapsed,
                            ),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Player controls
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Number of players: $_numberOfPlayers',
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _removePlayer,
                            color: Colors.blue,
                            iconSize: 32,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addPlayer,
                            color: Colors.blue,
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
