import 'package:flutter/material.dart';
import 'package:thefridge/core/theming/color_theme.dart';

late ColorTheme currentTheme;

// surfaces
Color get appColor => currentTheme.appColor;

Color get background => currentTheme.background;

Color get surface => currentTheme.surface;

Color get card => currentTheme.card;

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
