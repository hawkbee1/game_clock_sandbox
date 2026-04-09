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
      body: SafeArea(
        child: Stack(
          children: [
            // use flutter_svg to display SVG background, ensuring it scales properly across devices.
            SvgPicture.asset(
              'assets/background/background_large_cave.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            CustomMultiChildLayout(
              delegate: GameLayoutDelegate(isMobile && isPortrait),
              children: [
                LayoutId(id: 'controller', child: controller),
                LayoutId(id: 'player_clock', child: playerClock),
                LayoutId(id: 'team_controls', child: teamControls),
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

class GameLayoutDelegate extends MultiChildLayoutDelegate {
  final bool isPortraitMode;

  GameLayoutDelegate(this.isPortraitMode);

  @override
  void performLayout(Size size) {
    if (isPortraitMode) {
      // Logic for portrait: Column-like
      final controllerSize = layoutChild(
        'controller',
        BoxConstraints.loose(Size(size.width, size.height * 0.3)),
      );
      positionChild('controller', Offset.zero);

      final clockSize = layoutChild(
        'player_clock',
        BoxConstraints.loose(Size(size.width * 0.9, size.height * 0.44)),
      );
      positionChild(
        'player_clock',
        Offset((size.width - clockSize.width) / 2, controllerSize.height),
      );

      final controlsSize = layoutChild(
        'team_controls',
        BoxConstraints.loose(Size(size.width * 0.7, size.height * 0.2)),
      );
      positionChild(
        'team_controls',
        Offset(0, size.height - controlsSize.height),
      );
    } else {
      // Logic for landscape: Row-like
      final controllerSize = layoutChild(
        'controller',
        BoxConstraints.tight(Size(size.width * 0.3, size.height)),
      );
      positionChild('controller', Offset.zero);

      final clockSize = layoutChild(
        'player_clock',
        BoxConstraints.tight(Size(size.width * 0.35, size.height)),
      );
      positionChild('player_clock', Offset(controllerSize.width, 0));

      layoutChild(
        'team_controls',
        BoxConstraints.tight(Size(size.width * 0.3, size.height)),
      );
      positionChild(
        'team_controls',
        Offset(controllerSize.width + clockSize.width, 0),
      );
    }
  }

  @override
  bool shouldRelayout(covariant GameLayoutDelegate oldDelegate) {
    return oldDelegate.isPortraitMode != isPortraitMode;
  }
}
