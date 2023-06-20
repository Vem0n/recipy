import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'theme.dart';

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

      String apiUrl = 'http://10.0.2.2:8080/api/favourites';

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
      print(error);
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
    debugPrint(postId);

    String apiUrl = 'http://10.0.2.2:8080/api/favourite/$_id';

    try {
      setState(() {
        isConnecting = true;
      });
      Response response = await dio.delete(apiUrl);

      if (response.statusCode == 200) {

      } else {}
    } catch (e) {
      print(e.toString());
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
          ? Center(
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
                            Expanded(
                              flex: 1,
                              child: Row(
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
                            ),
                            TextButton(
                              onPressed: () {
                                deletePostHandler(item.itemid);
                                itemList.remove(item);
                              },
                              child: Expanded(
                                flex: 1,
                                child: IconTheme(
                                  data: themeModel.currentTheme.iconTheme,
                                  child: const Icon(Icons.cancel_outlined),
                                ),
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
