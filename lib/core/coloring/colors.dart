import 'package:flutter/material.dart';
import 'package:thefridge/core/coloring/color_theme.dart';

late ColorTheme currentTheme;

// surfaces
Color get appColor => currentTheme.appColor;

Color get background => currentTheme.background;

Color get shadow => currentTheme.shadow;

Color get appBarText => currentTheme.appBarText;

Color get surface => currentTheme.surface;

Color get card => currentTheme.card;

Color get accent => currentTheme.accent;

// text
Color get primaryText => currentTheme.primaryText;

Color get secondaryText => currentTheme.secondaryText;

// states
Color get successColor => currentTheme.success;

Color get warningColor => currentTheme.warning;

Color get errorColor => currentTheme.error;

void setCurrentTheme(ColorTheme theme) {
  currentTheme = theme;
}
