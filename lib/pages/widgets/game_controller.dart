import 'package:flutter/material.dart';
import '../../utils/duration_formatter.dart';

/// Displays the total game timer and play/stop controls.
class GameController extends StatelessWidget {
  final Duration gameElapsed;
  final bool isRunning;
  final VoidCallback onStartPause;
  final VoidCallback onFinish;

  const GameController({
    super.key,
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
