
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipy/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'theme.dart';

class RandomChoicePage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const RandomChoicePage({Key? key, required this.updateIndex})
      : super(key: key);

  @override
  State<RandomChoicePage> createState() => _RandomChoicePageState();
}

class _RandomChoicePageState extends State<RandomChoicePage> {
  bool isVegan = false;
  bool isPrimal = false;
  Color bgcPrimal = ThemeModel.darkThemeDisabledColor;
  Color bgcVegan = ThemeModel.darkThemeDisabledColor;
  String diet = '';

  void primalButtonHandler() {
    if (!isPrimal) {
      if (isVegan) {
        setState(() {
          isVegan = false;
        });
      }
      setState(() {
        isPrimal = true;
        diet = 'primal';
        bgcPrimal = ThemeModel.darkThemeEnabledColor;
        bgcVegan = ThemeModel.darkThemeDisabledColor;
      });
    } else {
      setState(() {
        isPrimal = false;
        diet = '';
        bgcPrimal = ThemeModel.darkThemeDisabledColor;
      });
    }
  }

  void veganButtonHandler() {
    if (!isVegan) {
      if (isPrimal) {
        setState(() {
          isPrimal = false;
        });
      }
      setState(() {
        isVegan = true;
        diet = 'vegetarian';
        bgcVegan = ThemeModel.darkThemeEnabledColor;
        bgcPrimal = ThemeModel.darkThemeDisabledColor;
      });
    } else {
      setState(() {
        isVegan = false;
        diet = '';
        bgcVegan = ThemeModel.darkThemeDisabledColor;
      });
    }
  }

  void randomSearchHandler() async {
    final dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiKey = config.apiKey;
    final queryParams = <String, dynamic>{
      'apiKey': apiKey,
      'tags': diet,
      'number': 5,
    };

    try {
      final response = await dio.get(
        'https://api.spoonacular.com/recipes/random',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        String itemId = responseData['recipes'][0]['id'].toString();
        int parsedId = int.parse(itemId);
        prefs.setInt('selectedRecipe', parsedId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
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
                  randomSearchHandler();
                  widget.updateIndex(6);
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
