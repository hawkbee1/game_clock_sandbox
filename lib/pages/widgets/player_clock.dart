import 'package:flutter/material.dart';
import '../../utils/duration_formatter.dart';

/// Displays the current player's clock with tap-to-switch functionality.
///
/// Design Pattern: State (GoF)
/// The widget presents two visual states — active (running) and paused — and
/// disables user interaction in the paused state to prevent accidental player
/// switches.
class PlayerClock extends StatelessWidget {
  final dynamic player;

  /// Whether the game is currently running. When [false] the clock shows a
  /// pause overlay and the tap gesture is disabled.
  final bool isRunning;
  final VoidCallback onTap;

  const PlayerClock({
    super.key,
    required this.player,
    required this.isRunning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (player == null) return const SizedBox.shrink();

    return GestureDetector(
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
    );
  }
}
