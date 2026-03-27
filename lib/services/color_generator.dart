import 'package:flutter/material.dart';

/// Design Pattern: Strategy
/// Defines an interface for color generation algorithms.
/// Concrete implementations can be swapped at runtime or in tests.
abstract class ColorGenerator {
  Color generate();
}
