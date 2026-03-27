import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'summary_page.dart';
import '../state/game_notifier.dart';
import '../utils/duration_formatter.dart';

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

    var children = [
      _GameController(
        gameElapsed: gameState.gameElapsed,
        isRunning: gameState.isRunning,
        onStartPause: gameState.isRunning
            ? notifier.pauseGame
            : notifier.startGame,
        onFinish: () => _finishGame(context, ref),
      ),
      _PlayerClock(
        player: gameState.currentPlayer,
        isRunning: gameState.isRunning,
        onTap: notifier.nextPlayer,
      ),
      _TeamControls(
        numberOfPlayers: gameState.numberOfPlayers,
        onAdd: notifier.addPlayer,
        onRemove: notifier.removePlayer,
      ),
    ];
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
                ? Column(children: children)
                : Row(children: children),
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

/// Displays the total game timer and play/stop controls.
class _GameController extends StatelessWidget {
  final Duration gameElapsed;
  final bool isRunning;
  final VoidCallback onStartPause;
  final VoidCallback onFinish;

  const _GameController({
    required this.gameElapsed,
    required this.isRunning,
    required this.onStartPause,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDuration(gameElapsed),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                onPressed: onStartPause,
                color: Colors.blue,
                iconSize: 48,
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: onFinish,
                color: Colors.red,
                iconSize: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Displays the current player's clock with tap-to-switch functionality.
///
/// Design Pattern: State (GoF)
/// The widget presents two visual states — active (running) and paused — and
/// disables user interaction in the paused state to prevent accidental player
/// switches.  The Guard Clause in [GameNotifier.nextPlayer] acts as a
/// secondary safety net at the business-logic layer.
class _PlayerClock extends StatelessWidget {
  final dynamic player;

  /// Whether the game is currently running. When [false] the clock shows a
  /// pause overlay and the tap gesture is disabled.
  final bool isRunning;
  final VoidCallback onTap;

  const _PlayerClock({
    required this.player,
    required this.isRunning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (player == null) return const SizedBox.shrink();

    return Expanded(
      flex: 3,
      child: GestureDetector(
        // Design Pattern: Guard Clause (UI layer)
        // Passing null disables the tap entirely when the game is not running,
        // preventing any player switch while the clock is paused.
        onTap: isRunning ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: player.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(player.avatar, size: 32),
                    const SizedBox(height: 4),
                    Text(
                      player.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatDuration(player.elapsed),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
              // Paused overlay — shown only when the game is not running.
              if (!isRunning)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.pause_circle_outline,
                      size: 64,
                      color: Colors.white70,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controls for adding/removing players.
class _TeamControls extends StatelessWidget {
  final int numberOfPlayers;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _TeamControls({
    required this.numberOfPlayers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Number of players: $numberOfPlayers',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onRemove,
                color: Colors.blue,
                iconSize: 32,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAdd,
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
