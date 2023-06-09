import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipy/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'theme.dart';
import 'package:logger/logger.dart';

class FavouritePage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const FavouritePage({Key? key, required this.updateIndex}) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<ListItem> itemList = [];
  bool isConnecting = true;
  var imageUrl;
  var chosenId;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    pagePopulator();
  }

  void pagePopulator() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Dio dio = Dio();
      String? token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      final url = config.apiUrl;

      String apiUrl = '$url/api/favourites';

      Response response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        List<dynamic> results = responseData['results'];

        List<ListItem> updatedItemList = [];

        for (var result in results) {
          String title = result['title'];
          int receivedId = int.parse(result['receivedId'].toString());
          String imageUrl = result['imageurl'];
          String itemId = result['_id'];

          ListItem listItem = ListItem(
            imageUrl: imageUrl,
            title: title,
            id: receivedId,
            itemid: itemId,
            index: updatedItemList.length,
          );
          updatedItemList.add(listItem);
        }

        setState(() {
          itemList = updatedItemList;
        });
      } else {}
    } catch (error) {
      logger.e('Something went wrong');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  void deletePostHandler(String postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    String? token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final _id = postId;
    final api = config.apiUrl;

    String apiUrl = '$api/api/favourite/$_id';

    try {
      setState(() {
        isConnecting = true;
      });
      Response response = await dio.delete(apiUrl);

      if (response.statusCode == 200) {

      } else {}
    } catch (e) {
      logger.e('Something went wrong');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();

    return Container(
      color: themeModel.currentTheme.primaryColor,
      child: isConnecting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : itemList.isEmpty
              ? Center(
                  child: Text(
                    'Nothing here yet!',
                    style: themeModel.currentTheme.textTheme.displayLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    ListItem item = itemList[index];

                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeModel.currentTheme
                                            .dialogBackgroundColor,
                                        width: 4),
                                    borderRadius: BorderRadius.circular(18),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: NetworkImage(item.imageUrl),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 200,
                                  child: TextButton(
                                    onPressed: () async {
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setInt('selectedRecipe', item.id);
                                      widget.updateIndex(6);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item.title,
                                        style: themeModel.currentTheme
                                            .textTheme.displaySmall,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                deletePostHandler(item.itemid);
                                itemList.remove(item);
                              },
                              child: IconTheme(
                                data: themeModel.currentTheme.iconTheme,
                                child: const Icon(Icons.cancel_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class ListItem {
  final String imageUrl;
  final String title;
  final int index;
  final int id;
  final String itemid;

  ListItem({
    required this.imageUrl,
    required this.title,
    required this.index,
    required this.id,
    required this.itemid,
  });
}
