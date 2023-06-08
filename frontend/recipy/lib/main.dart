import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'login.dart';
import 'register.dart';
import 'home_page.dart';
import 'favourite.dart';
import 'search_page.dart';
import 'result_page.dart';
import 'random_choice_page.dart';
import 'recipe_page.dart';

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
  int currentIndex = 7;
  final List<Widget> pages = [const LoginPage(), const RegistrationPage(), const HomePage(), FavouritePage(), SearchPage(), ResultPage(), RandomChoicePage(), RecipePage()];

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
                      if (currentIndex != 0 && currentIndex != 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 19),
                          child: TextButton(
                            onPressed: () {
                              debugPrint('One pole killed');
                            },
                            child: IconTheme(data: themeModel.currentTheme.iconTheme,
                              child: const Icon(
                                Icons.history,
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                      Text(
                        'Recipy',
                        style: themeModel.currentTheme.textTheme.displayLarge,
                      ),
                      if (currentIndex != 0 && currentIndex != 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 19),
                          child: TextButton(
                            onPressed: () {
                              debugPrint('One pole killed');
                            },
                            child: IconTheme(data: themeModel.currentTheme.iconTheme,
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
              bottomNavigationBar: currentIndex != 0 && currentIndex != 1
                  ? CurvedNavigationBar(
                    animationDuration: const Duration(milliseconds: 420),
                      color: themeModel.currentTheme.canvasColor,
                      backgroundColor: themeModel.currentTheme.primaryColor,
                      items: const [
                        Icon(Icons.shuffle),
                        Icon(Icons.add, size: 34,),
                        Icon(Icons.favorite)
                      ],
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

