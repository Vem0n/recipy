import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'theme.dart';

class ResultPage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const ResultPage({Key? key, required this.updateIndex}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<ListItem> itemList = [];

  @override
  void initState() {
    super.initState();
    pagePopulator();
  }

  void pagePopulator() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = Dio();
    final apiKey = config.apiKey;
    const baseUrl = 'https://api.spoonacular.com/recipes/findByIngredients';
    final ingredients = prefs.getString('ingredients');
    var encodedList;
    final savedList = prefs.getString('savedList');

    if (ingredients != null && savedList == null) {
      final response = await dio.get(baseUrl, queryParameters: {
        'apiKey': apiKey,
        'ingredients': ingredients,
        'number': '5'
      });

      if (response.statusCode == 200) {
        final data = response.data;
        prefs.remove('ingredients');

        itemList.clear();

        for (var i = 0; i < data.length; i++) {
          final item = data[i];
          itemList.add(ListItem(
            imageUrl: item['image'],
            title: item['title'],
            index: i,
            id: item['id'],
          ));

          encodedList =
              jsonEncode(itemList.map((item) => item.toJson()).toList());
          prefs.setString('savedList', encodedList);

          setState(() {});
        }
      } else {
        throw Exception('Failed to fetch recipes');
      }
    } else if (itemList.isEmpty && savedList != null) {
      final decodedList = jsonDecode(savedList) as List<dynamic>;
      final loadedItemList = decodedList
          .map((item) => ListItem(
                imageUrl: item['imageUrl'],
                title: item['title'],
                index: item['index'],
                id: item['id'],
              ))
          .toList();
      setState(() {
        itemList = loadedItemList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();

    Widget content;

    if (itemList.isEmpty) {
      content = Center(
        child: Text(
          'Nothing here yet!',
          style: themeModel.currentTheme.textTheme.displayLarge,
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int index) {
          ListItem item = itemList[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: TextButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int selectedId = itemList[index].id;
                  prefs.setInt('selectedRecipe', selectedId);
                  widget.updateIndex(6);
                },
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 80,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: themeModel
                                          .currentTheme.dialogBackgroundColor,
                                      width: 4),
                                  borderRadius: BorderRadius.circular(18),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(item.imageUrl),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                item.title,
                                style: themeModel
                                    .currentTheme.textTheme.displaySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(
      color: themeModel.currentTheme.primaryColor,
      child: content,
    );
  }
}

class ListItem {
  String imageUrl;
  String title;
  int index;
  int id;

  ListItem({
    required this.imageUrl,
    required this.title,
    required this.index,
    required this.id,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      imageUrl: json['imageUrl'],
      title: json['title'],
      index: json['index'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'index': index,
      'id': id,
    };
  }
}
