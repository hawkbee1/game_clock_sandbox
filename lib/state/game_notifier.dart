import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../services/color_generator.dart';

/// Design Pattern: Observer (Riverpod StateNotifier)
/// Encapsulates all game logic and exposes an immutable [GameState] stream.
/// Widgets observe state changes reactively — no business logic in the UI.
///
/// Also applies the Facade pattern: provides a simple API surface
/// (start, pause, reset, nextPlayer, etc.) hiding internal timer management.
class GameNotifier extends StateNotifier<GameState> {
  final ColorGenerator _colorGenerator;
  Timer? _ticker;
  final Stopwatch _gameStopwatch = Stopwatch();
  final List<Stopwatch> _playerStopwatches = [];

  GameNotifier({
    ColorGenerator? colorGenerator,
    int initialPlayerCount = 5,
  })  : _colorGenerator = colorGenerator ?? RandomColorGenerator(),
        super(const GameState()) {
    _initializePlayers(initialPlayerCount);
  }

  void _initializePlayers(int count) {
    final players = <Player>[];
    _playerStopwatches.clear();
    for (int i = 0; i < count; i++) {
      players.add(
        Player(
          id: 'player_${i + 1}',
          name: 'Player ${i + 1}',
          color: _colorGenerator.generate(),
        ),
      );
      _playerStopwatches.add(Stopwatch());
    }
    state = state.copyWith(players: players, currentPlayerIndex: 0);
  }

  /// Starts or resumes the game clock and the current player's clock.
  void startGame() {
    _gameStopwatch.start();
    _playerStopwatches[state.currentPlayerIndex].start();
    _startTicker();
    state = state.copyWith(isRunning: true);
  }

  /// Pauses both the game clock and the current player's clock.
  void pauseGame() {
    _gameStopwatch.stop();
    _playerStopwatches[state.currentPlayerIndex].stop();
    _stopTicker();
    state = state.copyWith(isRunning: false);
  }

  /// Resets all clocks and returns to the first player.
  void resetGame() {
    _gameStopwatch
      ..stop()
      ..reset();
    for (final sw in _playerStopwatches) {
      sw
        ..stop()
        ..reset();
    }
    _stopTicker();

    final resetPlayers =
        state.players.map((p) => p.copyWith(elapsed: Duration.zero)).toList();
    state = state.copyWith(
      isRunning: false,
      gameElapsed: Duration.zero,
      currentPlayerIndex: 0,
      players: resetPlayers,
    );
  }

  /// Switches to the next player (circular). Only works while running.
  void nextPlayer() {
    if (!state.isRunning) return;

    final currentIdx = state.currentPlayerIndex;
    _playerStopwatches[currentIdx].stop();

    final nextIdx = (currentIdx + 1) % state.numberOfPlayers;
    _playerStopwatches[nextIdx].start();

    state = _syncElapsed().copyWith(currentPlayerIndex: nextIdx);
  }

  /// Adds a new player if under the 10-player limit.
  void addPlayer() {
    if (state.numberOfPlayers >= 10) return;

    final newIndex = state.numberOfPlayers + 1;
    final newPlayer = Player(
      id: 'player_$newIndex',
      name: 'Player $newIndex',
      color: _colorGenerator.generate(),
    );
    _playerStopwatches.add(Stopwatch());
    state = state.copyWith(players: [...state.players, newPlayer]);
  }

  /// Removes the last player if above the 2-player minimum.
  void removePlayer() {
    if (state.numberOfPlayers <= 2) return;

    _playerStopwatches.removeLast();
    final updatedPlayers = List<Player>.from(state.players)..removeLast();
    var currentIdx = state.currentPlayerIndex;
    if (currentIdx >= updatedPlayers.length) {
      currentIdx = updatedPlayers.length - 1;
    }
    state = state.copyWith(
      players: updatedPlayers,
      currentPlayerIndex: currentIdx,
    );
  }

  /// Stops the game and returns final state with all elapsed times synced.
  GameState finishGame() {
    _gameStopwatch.stop();
    _playerStopwatches[state.currentPlayerIndex].stop();
    _stopTicker();

    final finalState = _syncElapsed().copyWith(isRunning: false);
    state = finalState;
    return finalState;
  }

  /// Synchronizes stopwatch elapsed times into the immutable state.
  GameState _syncElapsed() {
    final updatedPlayers = <Player>[];
    for (int i = 0; i < state.players.length; i++) {
      updatedPlayers.add(
        state.players[i].copyWith(elapsed: _playerStopwatches[i].elapsed),
      );
    }
    return state.copyWith(
      gameElapsed: _gameStopwatch.elapsed,
      players: updatedPlayers,
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      state = _syncElapsed();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}

/// Riverpod provider for [GameNotifier].
/// Design Pattern: Dependency Injection (via Riverpod provider overrides)
final gameNotifierProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
