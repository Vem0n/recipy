import 'package:flutter/material.dart';
import 'dart:async';
import 'config.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

/* TODO: Write suggestion logic (on tap append to list and view as object, add string to search query)
         Write diet button logic, on tap append to search query,
         Write search logic, on tap contacts API and passes result to resultPage(),
         Allow deletion of undesired ingredients from list
 */

bool isVegan = false;
bool isPrimal = false;
var bgcPrimal = colorButtonsDark.darkThemeDisabledColor;
var bgcVegan = colorButtonsDark.darkThemeDisabledColor;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required void Function(int newIndex) updateIndex});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class colorButtonsDark {
  static const Color darkThemeDisabledColor = Color.fromARGB(255, 131, 93, 93);
  static const Color darkThemeEnabledColor = Color.fromARGB(255, 132, 145, 60);
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _suggestions = [];
  Timer? _debounceTimer;

  @override
  void dispose() {
    _textEditingController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<List<String>> fetchIngredientSuggestions(
      String searchText, CancelToken cancelToken) async {
    final apiKey = config.apiKey;
    const baseUrl = 'https://api.spoonacular.com/food/ingredients/autocomplete';

    final dio = Dio();
    final response = await dio.get(
      baseUrl,
      queryParameters: {'apiKey': apiKey, 'query': searchText, 'number': 3},
      cancelToken: cancelToken,
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      final suggestions = data.map((item) => item['name'] as String).toList();
      return suggestions;
    } else {
      throw Exception('Failed to fetch ingredient suggestions');
    }
  }

  void _onTextChanged(String searchText) {
    _debounceTimer?.cancel();

    if (searchText.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final cancelToken = CancelToken();

      fetchIngredientSuggestions(searchText, cancelToken).then((suggestions) {
        if (!cancelToken.isCancelled) {
          setState(() {
            _suggestions = suggestions;
          });
        }
      }).catchError((error) {
        debugPrint('Error: $error');
      });
    });
  }

  void primalButtonHandler() {
    if (isPrimal == false) {
      if (isVegan == true) {
        isVegan = false;
      }
      isPrimal = true;
      bgcPrimal = colorButtonsDark.darkThemeEnabledColor;
      bgcVegan = colorButtonsDark.darkThemeDisabledColor;
    } else {
      isPrimal = false;
      bgcPrimal = colorButtonsDark.darkThemeDisabledColor;
    }
  }

  void veganButtonHandler() {
    if (isVegan == false) {
      if (isPrimal == true) {
        isPrimal = false;
      }
      isVegan = true;
      bgcVegan = colorButtonsDark.darkThemeEnabledColor;
      bgcPrimal = colorButtonsDark.darkThemeDisabledColor;
    } else {
      isVegan = false;
      bgcVegan = colorButtonsDark.darkThemeDisabledColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return Container(
      color: themeModel.currentTheme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 330,
                height: 60,
                child: Card(
                  elevation: 24,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: _onTextChanged,
                      decoration: InputDecoration(
                          prefixIcon: IconTheme(
                            data: themeModel.currentTheme.iconTheme,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      setState(() {
                        _textEditingController.text = suggestion;
                        _suggestions = [];
                      });
                    },
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 180,
                width: 360,
                child: Card(
                  elevation: 24,
                ),
              ),
              const SizedBox(height: 40),
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
                      splashColor: colorButtonsDark.darkThemeEnabledColor,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: IconTheme(
                          data: themeModel.currentTheme.iconTheme,
                          child: const ImageIcon(AssetImage('assets/images/meat.png'),
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
                      splashColor: colorButtonsDark.darkThemeEnabledColor,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
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
                child: TextButton(onPressed: () {
                  debugPrint('Things done');
                }, child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Text("Search!", style: themeModel.currentTheme.textTheme.displayMedium,),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
