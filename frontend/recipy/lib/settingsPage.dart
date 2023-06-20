import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class settingsPage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const settingsPage({Key? key, required this.updateIndex}) : super(key: key);

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  String theme = 'Dark';

  void themeButtonHandler() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (theme == 'Dark') {
      setState(() {
        theme = 'Light';
      });
      prefs.setString('theme', theme);
    } else if (theme == 'Light') {
      setState(() {
        theme = 'Dark';
      });
      prefs.setString('theme', theme);
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
          SizedBox(
            width: 300,
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              elevation: 22,
              child: TextButton(
                onPressed: () {
                  themeButtonHandler();
                },
                child: Text(
                  '$theme Theme',
                  style: themeModel.currentTheme.textTheme.displayMedium,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 300,
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              elevation: 22,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Delete Account',
                  style: themeModel.currentTheme.textTheme.displayMedium,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 300,
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 22,
              child: TextButton(
                onPressed: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('token');
                  widget.updateIndex(3);
                },
                child: Text(
                  'Log out',
                  style: themeModel.currentTheme.textTheme.displayMedium,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
