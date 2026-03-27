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
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
          fontSize: 36,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
