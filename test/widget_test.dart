// Widget tests for GamePage.
//
// Design Pattern: Humble View testing — all business logic lives in
// [GameNotifier]; these tests verify only that the UI reacts correctly to
// state changes exposed by the notifier.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_clock_sandbox/main.dart';
import 'package:game_clock_sandbox/pages/game_page.dart';
import 'package:game_clock_sandbox/services/color_generator.dart';
import 'package:game_clock_sandbox/state/game_notifier.dart';

/// Helper that wraps a widget with [ProviderScope] and [MaterialApp].
Widget makeTestable(Widget child, {GameNotifier? notifier}) {
  return ProviderScope(
    overrides: notifier != null
        ? [
            gameNotifierProvider.overrideWith((_) => notifier),
          ]
        : [],
    child: MaterialApp(home: child),
  );
}

void main() {
  // ------------------------------------------------------------------ smoke
  testWidgets('App renders without crashing', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Clock for your games'), findsOneWidget);
  });

  // -------------------------------------------------------- pause interaction
  group('_PlayerClock — tap while paused', () {
    testWidgets(
        'tapping the player clock while game is paused does NOT switch player',
        (tester) async {
      final notifier = GameNotifier(
        colorGenerator: FixedColorGenerator(const [Colors.red]),
        initialPlayerCount: 2,
      );

      await tester.pumpWidget(makeTestable(const GamePage(), notifier: notifier));

      // Initially not running: verify Player 1 is displayed.
      expect(find.text('Player 1'), findsOneWidget);
      expect(notifier.state.currentPlayerIndex, 0);

      // Start then immediately pause.
      notifier.startGame();
      notifier.pauseGame();
      await tester.pump();

      // Pause overlay should be visible.
      expect(find.byIcon(Icons.pause_circle_outline), findsOneWidget);

      // Tap the player clock area.
      await tester.tap(find.text('Player 1'));
      await tester.pump();

      // Player must NOT have switched.
      expect(notifier.state.currentPlayerIndex, 0,
          reason: 'tapping while paused must not advance the player');
      expect(find.text('Player 1'), findsOneWidget);
    });

    testWidgets(
        'tapping the player clock while game is running DOES switch player',
        (tester) async {
      final notifier = GameNotifier(
        colorGenerator: FixedColorGenerator(const [Colors.red]),
        initialPlayerCount: 2,
      );

      await tester.pumpWidget(makeTestable(const GamePage(), notifier: notifier));

      notifier.startGame();
      await tester.pump();

      // No pause overlay while running.
      expect(find.byIcon(Icons.pause_circle_outline), findsNothing);

      // Tap the player clock.
      await tester.tap(find.text('Player 1'));
      await tester.pump();

      expect(notifier.state.currentPlayerIndex, 1,
          reason: 'tapping while running must advance to the next player');
    });

    testWidgets('pause overlay is NOT shown while game is running',
        (tester) async {
      final notifier = GameNotifier(
        colorGenerator: FixedColorGenerator(const [Colors.red]),
        initialPlayerCount: 2,
      );

      await tester.pumpWidget(makeTestable(const GamePage(), notifier: notifier));

      notifier.startGame();
      await tester.pump();

      expect(find.byIcon(Icons.pause_circle_outline), findsNothing);
    });

    testWidgets('pause overlay is shown when game has not started yet',
        (tester) async {
      final notifier = GameNotifier(
        colorGenerator: FixedColorGenerator(const [Colors.red]),
        initialPlayerCount: 2,
      );

      await tester.pumpWidget(makeTestable(const GamePage(), notifier: notifier));
      await tester.pump();

      // Game not started → isRunning == false → overlay visible.
      expect(find.byIcon(Icons.pause_circle_outline), findsOneWidget);
    });
  });
}

