import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game_clock_sandbox/main.dart';

void main() {
  testWidgets('GamePage renders initial state correctly',
      (WidgetTester tester) async {
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

  testWidgets('Add player button increases player count',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Number of players: 5'), findsOneWidget);

    // Tap the add player button.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Number of players: 6'), findsOneWidget);
  });

  testWidgets('Remove player button decreases player count',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Number of players: 5'), findsOneWidget);

    // Tap the remove player button.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.text('Number of players: 4'), findsOneWidget);
  });

  testWidgets('Play button starts the game and switches to pause icon',
      (WidgetTester tester) async {
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
}
