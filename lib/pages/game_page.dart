import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'summary_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<Stopwatch> _playerStopwatches = [];
  final List<Color> _playerColors = [];
  final Stopwatch _gameStopwatch = Stopwatch();
  final Random _random = Random();
  int _currentPlayerIndex = 0;
  int _numberOfPlayers = 5;
  bool _isGameRunning = false;

  @override
  void initState() {
    super.initState();
    _initializeStopwatches();
    _startTimer();
  }

  Color _generateRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(128) + 128,
      _random.nextInt(128) + 128,
      _random.nextInt(128) + 128,
      1,
    );
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

  void _finishGame() async {
    _pauseGame();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameSummaryPage(
          gameDuration: _gameStopwatch.elapsed,
          playerDurations: _playerStopwatches.map((s) => s.elapsed).toList(),
          playerColors: _playerColors,
        ),
      ),
    );
    _resetGame();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile =
        Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

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
            child: (isMobile && isPortrait)
                ? Column(children: [gameController(), clock(), team()])
                : Row(children: [gameController(), clock(), team()]),
          ),
        ],
      ),
    );
  }

  Widget gameController() {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDuration(_gameStopwatch.elapsed),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isGameRunning ? Icons.pause : Icons.play_arrow),
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
    );
  }

  Widget clock() {
    return Expanded(
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _formatDuration(
                  _playerStopwatches[_currentPlayerIndex].elapsed,
                ),
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget team() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Number of players: $_numberOfPlayers',
            style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
