import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class RandomChoicePage extends StatefulWidget {
  const RandomChoicePage({super.key, required void Function(int newIndex) updateIndex});

  @override
  State<RandomChoicePage> createState() => _RandomChoicePageState();
}

bool isVegan = false;
bool isPrimal = false;
var bgcPrimal = ThemeModel.darkThemeDisabledColor;
var bgcVegan = ThemeModel.darkThemeDisabledColor;

void primalButtonHandler() {
  if (isPrimal == false) {
    if (isVegan == true) {
      isVegan = false;
    }
    isPrimal = true;
    bgcPrimal = ThemeModel.darkThemeEnabledColor;
    bgcVegan = ThemeModel.darkThemeDisabledColor;
  } else {
    isPrimal = false;
    bgcPrimal = ThemeModel.darkThemeDisabledColor;
  }
}

void veganButtonHandler() {
  if (isVegan == false) {
    if (isPrimal == true) {
      isPrimal = false;
    }
    isVegan = true;
    bgcVegan = ThemeModel.darkThemeEnabledColor;
    bgcPrimal = ThemeModel.darkThemeDisabledColor;
  } else {
    isVegan = false;
    bgcVegan = ThemeModel.darkThemeDisabledColor;
  }
}

class _RandomChoicePageState extends State<RandomChoicePage> {
  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return Container(
      color: themeModel.currentTheme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
              data: themeModel.currentTheme.iconTheme,
              child: const Icon(
                Icons.shuffle,
                size: 220,
              )),
          const SizedBox(
            height: 40,
          ),
          Text('Preferences',
              style: themeModel.currentTheme.textTheme.displayLarge),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      primalButtonHandler();
                    });
                    debugPrint('Based primal');
                  },
                  backgroundColor: bgcPrimal,
                  splashColor: ThemeModel.darkThemeEnabledColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: IconTheme(
                      data: themeModel.currentTheme.iconTheme,
                      child: const ImageIcon(
                          AssetImage('assets/images/meat.png'),
                          size: 44)),
                ),
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      veganButtonHandler();
                    });
                    debugPrint('Based vegan');
                  },
                  backgroundColor: bgcVegan,
                  splashColor: ThemeModel.darkThemeEnabledColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: IconTheme(
                      data: themeModel.currentTheme.iconTheme,
                      child: const ImageIcon(
                          AssetImage('assets/images/vegan.png'),
                          size: 44)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Card(
            elevation: 10,
            child: TextButton(
                onPressed: () {
                  debugPrint('Things done');
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Text(
                    "Search!",
                    style: themeModel.currentTheme.textTheme.displayMedium,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
