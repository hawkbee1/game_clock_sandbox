// Unit tests for [GameNotifier].
//
// Design Pattern: Arrange-Act-Assert (AAA)
// Each test follows the AAA structure: set up state, perform action, verify
// outcome. No UI or Riverpod scaffolding is needed because [GameNotifier]
// extends [StateNotifier] and can be instantiated directly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_clock_sandbox/services/fixed_color_generator.dart';
import 'package:game_clock_sandbox/state/game_notifier.dart';

/// Shared factory: creates a [GameNotifier] with predictable colours so tests
/// do not depend on random values.
GameNotifier _makeNotifier({int players = 3}) => GameNotifier(
      colorGenerator: FixedColorGenerator(const [
        Colors.red,
        Colors.green,
        Colors.blue,
      ]),
      initialPlayerCount: players,
    );

void main() {
  // ------------------------------------------------- nextPlayer while paused
  group('GameNotifier.nextPlayer — Guard Clause (paused / not started)', () {
    test('does NOT advance player when game has never been started', () {
      // Arrange
      final notifier = _makeNotifier();
      expect(notifier.state.currentPlayerIndex, 0);

      // Act
      notifier.nextPlayer();

      // Assert
      expect(notifier.state.currentPlayerIndex, 0,
          reason: 'player must not change before game starts');
    });

    test('does NOT advance player when game is paused', () {
      // Arrange
      final notifier = _makeNotifier();
      notifier.startGame();
      notifier.pauseGame();
      expect(notifier.state.isRunning, false);

      // Act
      notifier.nextPlayer();

      // Assert
      expect(notifier.state.currentPlayerIndex, 0,
          reason: 'player must not change while paused');
    });

    test('calling nextPlayer multiple times while paused keeps index at 0', () {
      final notifier = _makeNotifier();
      notifier.startGame();
      notifier.pauseGame();

      notifier.nextPlayer();
      notifier.nextPlayer();
      notifier.nextPlayer();

      expect(notifier.state.currentPlayerIndex, 0);
    });
  });

  // ------------------------------------------------- nextPlayer while running
  group('GameNotifier.nextPlayer — running state', () {
    test('advances to next player when game is running', () {
      // Arrange
      final notifier = _makeNotifier();
      notifier.startGame();

      // Act
      notifier.nextPlayer();

      // Assert
      expect(notifier.state.currentPlayerIndex, 1);
    });

    test('wraps around from last player back to first player', () {
      final notifier = _makeNotifier(players: 3);
      notifier.startGame();

      notifier.nextPlayer(); // 0 → 1
      notifier.nextPlayer(); // 1 → 2
      notifier.nextPlayer(); // 2 → 0 (wrap)

      expect(notifier.state.currentPlayerIndex, 0);
    });

    test('isRunning remains true after nextPlayer', () {
      final notifier = _makeNotifier();
      notifier.startGame();
      notifier.nextPlayer();

      expect(notifier.state.isRunning, true);
    });
  });

  // ----------------------------------------------- pause / resume cycle
  group('GameNotifier — pause / resume cycle', () {
    test('isRunning flips correctly between startGame and pauseGame', () {
      final notifier = _makeNotifier();
      expect(notifier.state.isRunning, false);

      notifier.startGame();
      expect(notifier.state.isRunning, true);

      notifier.pauseGame();
      expect(notifier.state.isRunning, false);

      notifier.startGame();
      expect(notifier.state.isRunning, true);
    });

    test('player index is preserved across a pause-resume cycle', () {
      final notifier = _makeNotifier();
      notifier.startGame();
      notifier.nextPlayer(); // advance to index 1

      notifier.pauseGame();
      expect(notifier.state.currentPlayerIndex, 1);

      // Tapping while paused should have no effect.
      notifier.nextPlayer();
      expect(notifier.state.currentPlayerIndex, 1);

      // Resume and switch normally.
      notifier.startGame();
      notifier.nextPlayer();
      expect(notifier.state.currentPlayerIndex, 2);
    });
  });

  // ----------------------------------------------- addPlayer / removePlayer
  group('GameNotifier — player management', () {
    test('addPlayer increases player count', () {
      final notifier = _makeNotifier(players: 2);
      notifier.addPlayer();
      expect(notifier.state.numberOfPlayers, 3);
    });

    test('removePlayer decreases player count', () {
      final notifier = _makeNotifier(players: 3);
      notifier.removePlayer();
      expect(notifier.state.numberOfPlayers, 2);
    });

    test('cannot have fewer than 2 players', () {
      final notifier = _makeNotifier(players: 2);
      notifier.removePlayer();
      expect(notifier.state.numberOfPlayers, 2);
    });

    test('cannot have more than 10 players', () {
      final notifier = _makeNotifier(players: 10);
      notifier.addPlayer();
      expect(notifier.state.numberOfPlayers, 10);
    });
  });

  // ----------------------------------------------- resetGame
  group('GameNotifier.resetGame', () {
    test('resets to initial state after a game', () {
      final notifier = _makeNotifier();
      notifier.startGame();
      notifier.nextPlayer();
      notifier.pauseGame();
      notifier.resetGame();

      expect(notifier.state.isRunning, false);
      expect(notifier.state.currentPlayerIndex, 0);
      expect(notifier.state.gameElapsed, Duration.zero);
      for (final p in notifier.state.players) {
        expect(p.elapsed, Duration.zero);
      }
    });
  });
}
