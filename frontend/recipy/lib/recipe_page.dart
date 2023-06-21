import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:recipy/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'theme.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key, required void Function(int newIndex) updateIndex})
      : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<String> ingredients = [];
  var imageUrl;
  String instructions = 'placeholder';
  bool isLoading = true;
  var saveId;
  var saveName;
  bool isFavourite = false;
  IconData favouriteIcon = Icons.favorite_border;
  var logger = Logger();

  String removeHtmlTags(String htmlText) {
    RegExp htmlTagsRegex = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(htmlTagsRegex, '');
  }

  void pagePopulator() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String chosenRecipeId = prefs.getInt('selectedRecipe').toString();

    final dio = Dio();
    final apiKey = config.apiKey;
    final url =
        'https://api.spoonacular.com/recipes/$chosenRecipeId/information';

    try {
      final response = await dio.get(url, queryParameters: {'apiKey': apiKey});

      if (response.statusCode == 200) {
        final recipeData = response.data;

        String capitalize(String input) {
          if (input.isEmpty) return '';
          return input[0].toUpperCase() + input.substring(1);
        }

        final List<dynamic> extendedIngredients =
            recipeData['extendedIngredients'];
        ingredients = extendedIngredients.map((ingredient) {
          final String name = capitalize(ingredient['name'].toString());

          double metricAmount = 0.0;
          if (ingredient['measures'] != null &&
              ingredient['measures']['metric'] != null &&
              ingredient['measures']['metric']['amount'] != null) {
            metricAmount =
                ingredient['measures']['metric']['amount'].toDouble();
          }

          String unit = '';
          if (ingredient['measures'] != null &&
              ingredient['measures']['metric'] != null &&
              ingredient['measures']['metric']['unitShort'] != null) {
            unit = ingredient['measures']['metric']['unitShort'];
          }

          String amountString =
              metricAmount > 0 ? metricAmount.round().toString() : '';

          return '$name${amountString.isNotEmpty ? ' | $amountString' : ''} | $unit';
        }).toList();

        imageUrl = recipeData['image'];
        saveName = capitalize(recipeData['title']);
        saveId = chosenRecipeId;
        instructions = removeHtmlTags(recipeData['instructions']);
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void favouriteHandler() async {
    if (isFavourite == false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      Map<String, dynamic> requestBody = {
        'title': saveName,
        'imageurl': imageUrl,
        'receivedId': saveId,
      };

      favouriteIcon = Icons.favorite;

      try {
        // ignore: unused_local_variable
        Response response = await dio.post('http://10.0.2.2:8080/api/favourite',
            data: requestBody);
      } catch (e) {
        logger.e('Failed loading the items');
      }
    } else if (isFavourite == false) {
      favouriteIcon = Icons.favorite_border;
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    pagePopulator();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();

    return Scaffold(
      backgroundColor: themeModel.currentTheme.primaryColor,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: SpinKitCircle(
                  color: Color.fromARGB(255, 80, 82, 201),
                  size: 50.0,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      Card(
                        elevation: 22,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
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
                              style: themeModel
                                  .currentTheme.textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
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
                                        style: themeModel.currentTheme.textTheme
                                            .displaySmall,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Recipe',
                            style:
                                themeModel.currentTheme.textTheme.displayMedium,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  favouriteHandler();
                                });
                              },
                              child: IconTheme(
                                  data: themeModel.currentTheme.iconTheme,
                                  child: Icon(favouriteIcon)))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        instructions,
                        style: themeModel.currentTheme.textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
