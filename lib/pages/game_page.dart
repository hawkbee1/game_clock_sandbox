import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      onStartPause: gameState.isRunning
          ? notifier.pauseGame
          : notifier.startGame,
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
      body: Stack(
        children: [
          // use flutter_svg to display SVG background, ensuring it scales properly across devices.
          SvgPicture.asset(
            'assets/background/background_large_cave.svg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: (isMobile && isPortrait)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(flex: 2, child: controller),
                      Spacer(),
                      Flexible(
                        flex: 3,
                        child: Row(
                          children: [
                            Spacer(),
                            Flexible(flex: 3, child: playerClock),
                            Spacer(),
                          ],
                        ),
                      ),
                      Spacer(),
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Flexible(flex: 4, child: teamControls),
                            Spacer(flex: 6),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(flex: 1, child: controller),
                      Flexible(flex: 3, child: playerClock),
                      Flexible(flex: 1, child: teamControls),
                    ],
                  ),
          ),
        ],
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
