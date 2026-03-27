import 'package:flutter/material.dart';
import 'color_generator.dart';

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
