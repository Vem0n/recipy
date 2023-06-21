import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'config.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class SearchPage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const SearchPage(
      {Key? key, required this.updateIndex}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _suggestions = [];
  List<String> _selectedIngredients = [];
  Timer? _debounceTimer;
  var logger = Logger();

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

  void searchHandler() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final snackBar = SnackBar(
      content: Text(
        'Search for ingredients first!',
        style: ThemeModel().currentTheme.textTheme.bodyLarge,
      ),
      duration: const Duration(seconds: 5), backgroundColor: ThemeModel().currentTheme.canvasColor,
    );

    if (_selectedIngredients.isNotEmpty) {
      final ingredients = _selectedIngredients.join(',');
      prefs.setString('ingredients', ingredients);
      prefs.remove('savedList');
      widget.updateIndex(5);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        logger.e('Something went wrong');
      });
    });
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
                        _suggestions = [];
                        _selectedIngredients.add(suggestion);
                        _textEditingController.text = '';
                      });
                    },
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 180,
                width: 360,
                child: Card(
                  elevation: 24,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _selectedIngredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = _selectedIngredients[index];
                            return ListTile(
                              title: Row(children: [
                                Expanded(child: Text(ingredient)),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedIngredients.remove(ingredient);
                                      });
                                    },
                                    child: IconTheme(
                                        data: themeModel.currentTheme.iconTheme,
                                        child:
                                            const Icon(Icons.cancel_outlined)))
                              ]),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 10,
                child: TextButton(
                    onPressed: () {
                      searchHandler();
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
        ),
      ),
    );
  }
}
