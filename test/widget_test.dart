// Widget tests for GamePage.
//
// Design Pattern: Humble View testing — all business logic lives in
// [GameNotifier]; these tests verify only that the UI reacts correctly to
// state changes exposed by the notifier.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_clock_sandbox/my_app.dart';
import 'package:game_clock_sandbox/pages/game_page.dart';
import 'package:game_clock_sandbox/services/fixed_color_generator.dart';
import 'package:game_clock_sandbox/state/game_notifier.dart';

/// Helper that wraps a widget with [ProviderScope] and [MaterialApp].
Widget makeTestable(Widget child, {GameNotifier? notifier}) {
  return ProviderScope(
    overrides: notifier != null
        ? [gameNotifierProvider.overrideWith((_) => notifier)]
        : [],
    child: MaterialApp(home: child),
  );
}

void main() {
  // ------------------------------------------------------------------ smoke / initial state
  testWidgets('GamePage renders initial state correctly', (
    WidgetTester tester,
  ) async {
    // Wrap with ProviderScope as required by Riverpod.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    // Verify the app bar title is present.
    expect(find.text('Clock for your games'), findsOneWidget);

    // Verify the game timer starts at 00:00:00.
    expect(find.text('00:00:00'), findsWidgets);

    // Verify Player 1 is shown.
    expect(find.text('Player 1'), findsOneWidget);

    // Verify the player count label is displayed.
    expect(find.text('Number of players: 5'), findsOneWidget);

    // Verify play button is present (game not running initially).
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsOneWidget);
  });

  testWidgets('Add player button increases player count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Number of players: 5'), findsOneWidget);

    // Tap the add player button.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Number of players: 6'), findsOneWidget);
  });

  testWidgets('Remove player button decreases player count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Number of players: 5'), findsOneWidget);

    // Tap the remove player button.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.text('Number of players: 4'), findsOneWidget);
  });

  testWidgets('Play button starts the game and switches to pause icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Initially should show play icon.
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsNothing);

    // Tap play.
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    // Now should show pause icon.
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
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

        await tester.pumpWidget(
          makeTestable(const GamePage(), notifier: notifier),
        );

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
        expect(
          notifier.state.currentPlayerIndex,
          0,
          reason: 'tapping while paused must not advance the player',
        );
        expect(find.text('Player 1'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping the player clock while game is running DOES switch player',
      (tester) async {
        final notifier = GameNotifier(
          colorGenerator: FixedColorGenerator(const [Colors.red]),
          initialPlayerCount: 2,
        );

        await tester.pumpWidget(
          makeTestable(const GamePage(), notifier: notifier),
        );

        notifier.startGame();
        await tester.pump();

        // No pause overlay while running.
        expect(find.byIcon(Icons.pause_circle_outline), findsNothing);

        // Tap the player clock.
        await tester.tap(find.text('Player 1'));
        await tester.pump();

        expect(
          notifier.state.currentPlayerIndex,
          1,
          reason: 'tapping while running must advance to the next player',
        );
      },
    );

    testWidgets('pause overlay is NOT shown while game is running', (
      tester,
    ) async {
      final notifier = GameNotifier(
        colorGenerator: FixedColorGenerator(const [Colors.red]),
        initialPlayerCount: 2,
      );

      await tester.pumpWidget(
        makeTestable(const GamePage(), notifier: notifier),
      );

      notifier.startGame();
      await tester.pump();

      expect(find.byIcon(Icons.pause_circle_outline), findsNothing);
    });

    testWidgets('pause overlay is shown when game has not started yet', (
      tester,
    ) async {
      final notifier = GameNotifier(
        colorGenerator: FixedColorGenerator(const [Colors.red]),
        initialPlayerCount: 2,
      );

      await tester.pumpWidget(
        makeTestable(const GamePage(), notifier: notifier),
      );
      await tester.pump();

      // Game not started → isRunning == false → overlay visible.
      expect(find.byIcon(Icons.pause_circle_outline), findsOneWidget);
    });
  });
}
