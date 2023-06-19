import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ThemeModel extends ChangeNotifier {
  static const Color primaryColorLight = Color.fromARGB(255, 225, 225, 225);
  static const Color primaryColorDark = Color.fromARGB(255, 48, 48, 48);
  static const Color secondaryColorLight = Color.fromARGB(255, 206, 200, 200);
  static const Color secondaryColorDark = Color.fromARGB(255, 36, 35, 35);
  static const Color darkThemeTextColor = Color.fromARGB(255, 240, 171, 81);
  static const Color lightThemeTextColor = Color.fromARGB(255, 8, 8, 8);
  static const Color darkThemeDisabledColor = Color.fromARGB(255, 131, 93, 93);
  static const Color darkThemeEnabledColor = Color.fromARGB(255, 132, 145, 60);

  ThemeData _currentTheme = _buildDarkTheme();
  Timer? _themeControllerTimer;

  ThemeData get currentTheme => _currentTheme;

  ThemeModel() {
    _loadTheme();
    _startWatchingThemeChanges();
  }

  void _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeController = prefs.getString('theme');
    if (themeController == 'Dark') {
      _currentTheme = _buildDarkTheme();
    } else if (themeController == 'Light') {
      _currentTheme = _buildLightTheme();
    }
    notifyListeners();
  }

  void _startWatchingThemeChanges() {
    _themeControllerTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _loadTheme();
    });
  }

  @override
  void dispose() {
    _themeControllerTimer?.cancel();
    super.dispose();
  }


  static ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColorLight,
      iconTheme: const IconThemeData(color: lightThemeTextColor, size: 24),
      canvasColor: secondaryColorLight,
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: lightThemeTextColor),
          displayMedium: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: lightThemeTextColor),
          bodyLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontFamily: 'OpenSans',
              color: lightThemeTextColor),
          bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'OpenSans',
              color: lightThemeTextColor)),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColorDark,
        iconTheme: const IconThemeData(color: darkThemeTextColor, size: 24),
        canvasColor: secondaryColorDark,
        textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: darkThemeTextColor),
            displayMedium: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: darkThemeTextColor),
            bodyLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'OpenSans',
                color: darkThemeTextColor),
            bodySmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: 'OpenSans',
                color: darkThemeTextColor)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: darkThemeDisabledColor,
            splashColor: darkThemeEnabledColor));
  }
}

final themeProvider =
    ChangeNotifierProvider<ThemeModel>(create: (ref) => ThemeModel());
