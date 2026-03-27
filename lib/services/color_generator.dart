import 'dart:math';
import 'package:flutter/material.dart';

/// Design Pattern: Strategy
/// Defines an interface for color generation algorithms.
/// Concrete implementations can be swapped at runtime or in tests.
abstract class ColorGenerator {
  Color generate();
}

/// Default implementation using random pastel colors.
/// Generates colors with RGB values in [128..255] for a soft, pastel look.
class RandomColorGenerator implements ColorGenerator {
  final Random _random;

  RandomColorGenerator({Random? random}) : _random = random ?? Random();

  @override
  Color generate() {
    return Color.fromRGBO(
      _random.nextInt(128) + 128,
      _random.nextInt(128) + 128,
      _random.nextInt(128) + 128,
      1,
    );
  }
}

/// A fixed-sequence color generator useful for testing and golden tests.
class FixedColorGenerator implements ColorGenerator {
  final List<Color> _colors;
  int _index = 0;

  FixedColorGenerator(this._colors) : assert(_colors.isNotEmpty);

  @override
  Color generate() {
    final color = _colors[_index % _colors.length];
    _index++;
    return color;
  }
}
