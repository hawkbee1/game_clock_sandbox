import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
  final List<Color> _playerColors = [];
  final Stopwatch _gameStopwatch = Stopwatch();
  final Random _random = Random();
  int _currentPlayerIndex = 0;
  int _numberOfPlayers = 5;
  bool _isGameRunning = false;
  bool _showSummary = false;

  Color _generateRandomColor() {
    // Generate pastel colors for better readability
    return Color.fromRGBO(
      _random.nextInt(128) + 128, // Red component between 128-255
      _random.nextInt(128) + 128, // Green component between 128-255
      _random.nextInt(128) + 128, // Blue component between 128-255
      1, // Full opacity
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeStopwatches();
    _startTimer();
  }

  void _initializeStopwatches() {
    _playerStopwatches.clear();
    _playerColors.clear();
    for (int i = 0; i < _numberOfPlayers; i++) {
      _playerStopwatches.add(Stopwatch());
      _playerColors.add(_generateRandomColor());
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
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
        _playerColors.add(_generateRandomColor());
      });
    }
  }

  void _removePlayer() {
    if (_numberOfPlayers > 2) {
      setState(() {
        _numberOfPlayers--;
        _playerStopwatches.removeLast();
        _playerColors.removeLast();
        if (_currentPlayerIndex >= _numberOfPlayers) {
          _currentPlayerIndex = _numberOfPlayers - 1;
        }
      });
    }
  }

  void _finishGame() {
    setState(() {
      _isGameRunning = false;
      _gameStopwatch.stop();
      _playerStopwatches[_currentPlayerIndex].stop();
      _showSummary = true;
    });
  }

  void _startNewGame() {
    setState(() {
      _showSummary = false;
      _resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSummary) {
      return GameSummaryScreen(
        gameDuration: _gameStopwatch.elapsed,
        playerDurations: _playerStopwatches.map((s) => s.elapsed).toList(),
        playerColors: _playerColors,
        onNewGame: _startNewGame,
      );
    }

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
                            onPressed: _finishGame,
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
                        color: _playerColors[_currentPlayerIndex],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Player: ${_currentPlayerIndex + 1}',
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDuration(
                              _playerStopwatches[_currentPlayerIndex].elapsed,
                            ),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
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

class GameSummaryScreen extends StatelessWidget {
  final Duration gameDuration;
  final List<Duration> playerDurations;
  final List<Color> playerColors;
  final VoidCallback onNewGame;

  const GameSummaryScreen({
    super.key,
    required this.gameDuration,
    required this.playerDurations,
    required this.playerColors,
    required this.onNewGame,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String centiseconds = twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return "$minutes:$seconds:$centiseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Game Summary', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Total Game Time',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDuration(gameDuration),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Player Times',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text('Player',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('% of Game',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: List.generate(
                        playerDurations.length,
                        (index) {
                          final duration = playerDurations[index];
                          final percentage = (duration.inMilliseconds /
                                  gameDuration.inMilliseconds *
                                  100)
                              .toStringAsFixed(1);
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: playerColors[index],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Player ${index + 1}'),
                                  ],
                                ),
                              ),
                              DataCell(Text(_formatDuration(duration))),
                              DataCell(Text('$percentage%')),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: onNewGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.replay),
                  SizedBox(width: 8),
                  Text('Start New Game', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
