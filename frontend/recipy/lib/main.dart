import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'login.dart';
import 'register.dart';
import 'favourite.dart';
import 'search_page.dart';
import 'result_page.dart';
import 'random_choice_page.dart';
import 'recipe_page.dart';
import 'settingsPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 3;
  int navbarState = 0;
  int defaultNavbarIndex = 1;
  IconData iconData = Icons.history;

  void updateCurrentIndex(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    pages = [
      RandomChoicePage(updateIndex: updateCurrentIndex),
      SearchPage(updateIndex: updateCurrentIndex),
      FavouritePage(updateIndex: updateCurrentIndex),
      LoginPage(updateIndex: updateCurrentIndex),
      RegistrationPage(updateIndex: updateCurrentIndex),
      ResultPage(updateIndex: updateCurrentIndex),
      RecipePage(updateIndex: updateCurrentIndex),
      settingsPage(updateIndex: updateCurrentIndex),
    ];

    if (currentIndex == 6) {
      iconData = Icons.arrow_back_ios_new;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, _) {
          return MaterialApp(
            title: 'My App',
            theme: themeModel.currentTheme,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (currentIndex != 3 && currentIndex != 4)
                        Padding(
                          padding: const EdgeInsets.only(top: 19),
                          child: TextButton(
                            onPressed: () {
                              updateCurrentIndex(5);
                            },
                            child: IconTheme(
                              data: themeModel.currentTheme.iconTheme,
                              child: Icon(
                                iconData,
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                      Text(
                        'Recipy',
                        style: themeModel.currentTheme.textTheme.displayLarge,
                      ),
                      if (currentIndex != 3 && currentIndex != 4)
                        Padding(
                          padding: const EdgeInsets.only(top: 19),
                          child: TextButton(
                            onPressed: () {
                              updateCurrentIndex(7);
                            },
                            child: IconTheme(
                              data: themeModel.currentTheme.iconTheme,
                              child: const Icon(
                                Icons.account_circle_outlined,
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Expanded(child: pages[currentIndex]),
                ],
              ),
              bottomNavigationBar: currentIndex != 3 && currentIndex != 4
                  ? CurvedNavigationBar(
                      animationDuration: const Duration(milliseconds: 420),
                      color: themeModel.currentTheme.canvasColor,
                      backgroundColor: themeModel.currentTheme.primaryColor,
                      index: defaultNavbarIndex,
                      items: const [
                        Icon(Icons.shuffle),
                        Icon(
                          Icons.add,
                          size: 34,
                        ),
                        Icon(Icons.favorite)
                      ],
                      onTap: (index) {
                        setState(() {
                          navbarState = index;
                          currentIndex = navbarState;
                        });
                      },
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
