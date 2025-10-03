import 'package:flutter/material.dart';

class ColorTheme {
  final Color appColor;
  final Color background;
  final Color surface;
  final Color card;
  final Color primaryText;
  final Color secondaryText;
  final Color success;
  final Color warning;
  final Color error;

  const ColorTheme({
    required this.appColor,
    required this.background,
    required this.surface,
    required this.card,
    required this.primaryText,
    required this.secondaryText,
    required this.success,
    required this.warning,
    required this.error,
  });
}

final lightTheme = ColorTheme(
  appColor: Colors.blue,
  background: Colors.white,
  surface: Colors.grey.shade100,
  card: Colors.white,
  primaryText: Colors.black,
  secondaryText: Colors.grey.shade600,
  success: Colors.green,
  warning: Colors.orange,
  error: Colors.red,
);

final darkTheme = ColorTheme(
  appColor: Colors.tealAccent,
  background: Colors.black,
  surface: Colors.grey.shade900,
  card: Colors.grey.shade800,
  primaryText: Colors.white,
  secondaryText: Colors.grey.shade400,
  success: Colors.greenAccent,
  warning: Colors.orangeAccent,
  error: Colors.redAccent,
);

extension ColorExtension on Color {
  MaterialColor toMaterialColor() {
    final swatch = <int, Color>{
      50: withValues(alpha: 0.1),
      100: withValues(alpha: 0.2),
      200: withValues(alpha: 0.3),
      300: withValues(alpha: 0.4),
      400: withValues(alpha: 0.5),
      500: withValues(alpha: 0.6),
      600: withValues(alpha: 0.7),
      700: withValues(alpha: 0.8),
      800: withValues(alpha: 0.9),
      900: this,
    };
    return MaterialColor(toARGB32(), swatch);
  }
}
