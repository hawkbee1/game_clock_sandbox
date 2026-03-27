import 'player.dart';

/// Design Pattern: Value Object
/// Immutable state representation for the entire game session.
/// Observed by widgets via Riverpod (Observer pattern).
class GameState {
  final int currentPlayerIndex;
  final bool isRunning;
  final Duration gameElapsed;
  final List<Player> players;

  const GameState({
    this.currentPlayerIndex = 0,
    this.isRunning = false,
    this.gameElapsed = Duration.zero,
    this.players = const [],
  });

  /// The currently active player, or null if no players exist.
  Player? get currentPlayer =>
      players.isNotEmpty ? players[currentPlayerIndex] : null;

  /// Number of players in the game.
  int get numberOfPlayers => players.length;

  /// Returns a copy of this state with the given fields replaced.
  GameState copyWith({
    int? currentPlayerIndex,
    bool? isRunning,
    Duration? gameElapsed,
    List<Player>? players,
  }) {
    return GameState(
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      isRunning: isRunning ?? this.isRunning,
      gameElapsed: gameElapsed ?? this.gameElapsed,
      players: players ?? this.players,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          currentPlayerIndex == other.currentPlayerIndex &&
          isRunning == other.isRunning &&
          gameElapsed == other.gameElapsed &&
          _listEquals(players, other.players);

  @override
  int get hashCode =>
      currentPlayerIndex.hashCode ^
      isRunning.hashCode ^
      gameElapsed.hashCode ^
      players.hashCode;

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'GameState(players: ${players.length}, current: $currentPlayerIndex, running: $isRunning)';
}
