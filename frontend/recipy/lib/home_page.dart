import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    final assetPath = themeModel.currentTheme.brightness == Brightness.light
        ? 'assets/images/catLightmode.png'
        : 'assets/images/catDarkmode.png';
    
    return Container(
      color: themeModel.currentTheme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath),
          Text('Search for a recipe!', style: themeModel.currentTheme.textTheme.displayLarge,)
        ],
      ),
    );
  }
}