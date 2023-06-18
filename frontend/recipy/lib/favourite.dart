import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key, required void Function(int newIndex) updateIndex}) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<ListItem> itemList = [
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 0),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 1),
  ];

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

          return ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        IconTheme(
                            data: themeModel.currentTheme.iconTheme,
                            child: const Icon(Icons.image)),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 250,
                          child: TextButton(
                              onPressed: () {
                                debugPrint('It works');
                              },
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.title,
                                    style: themeModel
                                        .currentTheme.textTheme.bodyLarge,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        debugPrint('Deleted');
                      },
                      child: Expanded(
                        flex: 1,
                        child: IconTheme(
                          data: themeModel.currentTheme.iconTheme,
                          child: const Icon(Icons.cancel_outlined),
                        ),
                      ))
                ],
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
  final String imageUrl;
  final String title;
  final int index;

  ListItem({
    required this.imageUrl,
    required this.title,
    required this.index,
  });
}
