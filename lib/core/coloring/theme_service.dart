import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefridge/core/coloring/app_theme.dart';
import 'package:thefridge/core/coloring/color_theme.dart';
import 'package:thefridge/core/coloring/colors.dart';
import 'package:thefridge/root_app_widget.dart';

class ThemeService {
  static const _themeKey = 'app_theme';

  static Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString == 'dark') {
      currentTheme = darkTheme;
    } else {
      currentTheme = lightTheme; // default
    }
  }

  static Future<void> setTheme(AppThemeType type, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, type.name);

    currentTheme = type == AppThemeType.dark ? darkTheme : lightTheme;

    Future.delayed(Duration(milliseconds: 200), () {
      if (context.mounted) RootAppWidget.of(context).redrawApp();
    });
  }
}
