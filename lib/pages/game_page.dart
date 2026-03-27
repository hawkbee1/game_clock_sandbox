import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'summary_page.dart';
import '../state/game_notifier.dart';
import 'widgets/game_controller.dart';
import 'widgets/player_clock.dart';
import 'widgets/team_controls.dart';

/// Design Pattern: Presentation (Humble View)
/// This widget is purely presentational — all state is read from [GameNotifier]
/// via Riverpod, and all actions delegate to notifier methods.
class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final notifier = ref.read(gameNotifierProvider.notifier);
    final mediaQuery = MediaQuery.of(context);
    final isMobile =
        Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    final controller = GameController(
      gameElapsed: gameState.gameElapsed,
      isRunning: gameState.isRunning,
      onStartPause: gameState.isRunning ? notifier.pauseGame : notifier.startGame,
      onFinish: () => _finishGame(context, ref),
    );

    final playerClock = PlayerClock(
      player: gameState.currentPlayer,
      isRunning: gameState.isRunning,
      onTap: notifier.nextPlayer,
    );

    final teamControls = TeamControls(
      numberOfPlayers: gameState.numberOfPlayers,
      onAdd: notifier.addPlayer,
      onRemove: notifier.removePlayer,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Clock for your games',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (isMobile && isPortrait)
                ? Column(
                    children: [
                      controller,
                      // In Column under SingleChildScrollView, Expanded would crash.
                      // We use it as-is, letting it take its natural height.
                      playerClock,
                      teamControls,
                    ],
                  )
                : Row(
                    children: [
                      controller,
                      // In Row, we want the clock to take available horizontal space.
                      Expanded(flex: 3, child: playerClock),
                      teamControls,
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _finishGame(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gameNotifierProvider.notifier);
    final finalState = notifier.finishGame();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameSummaryPage(
          gameDuration: finalState.gameElapsed,
          players: finalState.players,
        ),
      ),
    ).then((_) => notifier.resetGame());
  }
}
