import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<ListItem> itemList = [
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 0),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 1),
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 2),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 3),
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 4),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 5),
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 6),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 7),
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 8),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 9),
    ListItem(imageUrl: 'your_image_url_1', title: 'Title 1', index: 10),
    ListItem(imageUrl: 'your_image_url_2', title: 'Title 2', index: 11),
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: TextButton(
                onPressed: () {
                  debugPrint('Card tapped');
                },
                child: ListTile(
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
                                child: const Icon(Icons.image),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style:
                                      themeModel.currentTheme.textTheme.bodyLarge,
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
