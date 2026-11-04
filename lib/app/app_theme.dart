import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => _make(Brightness.light);
  static ThemeData get dark => _make(Brightness.dark);
  static ThemeData _make(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF245B78), brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      cardTheme: const CardThemeData(margin: EdgeInsets.zero),
    );
  }
}
