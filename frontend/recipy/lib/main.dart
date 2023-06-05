import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    var pages = [LoginPage()];
    var index = pages[0];
    bool isUser = false;
    if (index != pages[0]) {
      isUser = true;
    }

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
                    if (isUser) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 19),
                        child: TextButton(
                            onPressed: () {
                              debugPrint('One pole killed');
                            },
                            child: const Icon(
                              Icons.history,
                              size: 38,
                            )),
                      ),
                      Text('Recipy',
                          style:
                              themeModel.currentTheme.textTheme.displayLarge),
                      Padding(
                        padding: const EdgeInsets.only(top: 19),
                        child: TextButton(
                            onPressed: () {
                              debugPrint('One pole killed');
                            },
                            child: const Icon(
                              Icons.account_circle_outlined,
                              size: 38,
                            )),
                      ),
                    ]
                  ],
                ),
                Expanded(child: index),
              ],
            )),
          );
        },
      ),
    );
  }
}
