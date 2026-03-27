import 'dart:math';
import 'package:flutter/material.dart';
import 'color_generator.dart';

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
