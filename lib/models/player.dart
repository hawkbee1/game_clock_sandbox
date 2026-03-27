import 'package:flutter/material.dart';

/// Design Pattern: Value Object
/// An immutable record representing a single player in the game.
/// Contains identity (id, name), visual (color, avatar) and timing (elapsed) data.
class Player {
  final String id;
  final String name;
  final Color color;
  final IconData avatar;
  final Duration elapsed;

  const Player({
    required this.id,
    required this.name,
    required this.color,
    this.avatar = Icons.person,
    this.elapsed = Duration.zero,
  });

  /// Returns a copy of this player with the given fields replaced.
  Player copyWith({
    String? id,
    String? name,
    Color? color,
    IconData? avatar,
    Duration? elapsed,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      avatar: avatar ?? this.avatar,
      elapsed: elapsed ?? this.elapsed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color &&
          avatar == other.avatar &&
          elapsed == other.elapsed;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      color.hashCode ^
      avatar.hashCode ^
      elapsed.hashCode;

  @override
  String toString() => 'Player(id: $id, name: $name, elapsed: $elapsed)';
}
