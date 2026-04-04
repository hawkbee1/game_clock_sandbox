import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/duration_formatter.dart';

/// Design Pattern: Presentation (Humble View)
/// Purely displays the game summary data — no logic beyond formatting.
class GameSummaryPage extends StatelessWidget {
  final Duration gameDuration;
  final List<Player> players;

  const GameSummaryPage({
    super.key,
    required this.gameDuration,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Text(
                              'Total Game Time',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatDuration(gameDuration),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Player Times',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 8,
                        sortAscending: true,
                        sortColumnIndex: 2,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Player',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text(
                              '% of Game',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: List.generate(players.length, (index) {
                          final player = players[index];
                          final percentage = gameDuration.inMilliseconds > 0
                              ? (player.elapsed.inMilliseconds /
                                        gameDuration.inMilliseconds *
                                        100)
                                    .toStringAsFixed(1)
                              : '0.0';
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: player.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(player.avatar, size: 16),
                                    const SizedBox(width: 4),
                                    Text(player.name),
                                  ],
                                ),
                              ),
                              DataCell(Text(formatDuration(player.elapsed))),
                              DataCell(
                                Text(
                                  '$percentage%',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.replay),
                    SizedBox(width: 8),
                    Text('Start New Game', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
