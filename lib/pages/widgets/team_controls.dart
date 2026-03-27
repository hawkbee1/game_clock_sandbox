import 'package:flutter/material.dart';

/// Controls for adding/removing players.
class TeamControls extends StatelessWidget {
  final int numberOfPlayers;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const TeamControls({
    super.key,
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
