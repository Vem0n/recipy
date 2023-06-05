import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeModel extends ChangeNotifier {
  // Define your colors here
  static const Color primaryColorLight = Color.fromARGB(255, 225, 225, 225);
  static const Color primaryColorDark = Color.fromARGB(255, 48, 48, 48);
  static const Color secondaryColorLight = Color.fromARGB(255, 206, 200, 200);
  static const Color secondaryColorDark = Color.fromARGB(255, 36, 35, 35);
  static const Color darkThemeTextColor = Color.fromARGB(255, 240, 171, 81);
  static const Color lightThemeTextColor = Color.fromARGB(255, 8, 8, 8);

  ThemeData _currentTheme = _buildDarkTheme();

  ThemeData get currentTheme => _currentTheme;

  void setTheme(bool isDarkMode) {
    _currentTheme = isDarkMode ? _buildDarkTheme() : _buildLightTheme();
    notifyListeners();
  }

  static ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColorLight,
      iconTheme: const IconThemeData(color: lightThemeTextColor, size: 24),
      canvasColor: secondaryColorLight,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            color: lightThemeTextColor),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'OpenSans',
          color: lightThemeTextColor
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'OpenSans',
          color: lightThemeTextColor
        )
      ),
      // Define other light theme properties
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
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'OpenSans',
          color: darkThemeTextColor
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'OpenSans',
          color: darkThemeTextColor
        )
      ),
      // Define other dark theme properties
    );
  }
}

final themeProvider =
    ChangeNotifierProvider<ThemeModel>(create: (ref) => ThemeModel());
