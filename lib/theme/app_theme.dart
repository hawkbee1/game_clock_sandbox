import 'package:flutter/material.dart';

/// Design Pattern: Single Responsibility
/// Centralizes the application's visual theme definition.
/// Separates look-and-feel configuration from app bootstrapping logic.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      // We keep the theme minimal to match the original design and 
      // ensure test stability, while providing a hook for future styling.
    );
  }
}
