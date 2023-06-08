import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<String> ingredients = [
    'Ingredient 1',
    'Ingredient 2',
    'Ingredient 3',
    'Ingredient 4',
    'Ingredient 5',
    'Ingredient 6',
    'Ingredient 7',
    'Ingredient 8',
    'Ingredient 9',
  ];

  String instructions =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique malesuada enim a scelerisque. Donec cursus convallis nunc at dapibus. Vestibulum vestibulum ex sed ultrices bibendum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique malesuada enim a scelerisque. Donec cursus convallis nunc at dapibus. Vestibulum vestibulum ex sed ultrices bibendum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique malesuada enim a scelerisque. Donec cursus convallis nunc at dapibus. Vestibulum vestibulum ex sed ultrices bibendum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique malesuada enim a scelerisque. Donec cursus convallis nunc at dapibus. Vestibulum vestibulum ex sed ultrices bibendum.';

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();

    return Scaffold(
      backgroundColor: themeModel.currentTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              IconTheme(
                data: themeModel.currentTheme.iconTheme,
                child: Icon(
                  Icons.image,
                  size: 220,
                ),
              ),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients:',
                        style: themeModel.currentTheme.textTheme.displayMedium,
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            String ingredient = ingredients[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ingredient,
                                  style: themeModel.currentTheme.textTheme.bodyLarge,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Recipe',
                  style: themeModel.currentTheme.textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  instructions,
                  style: themeModel.currentTheme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
