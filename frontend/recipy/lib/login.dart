import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return Container(
        color: themeModel.currentTheme.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 360,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Nice to see you!',
                    style: themeModel.currentTheme.textTheme.displayLarge,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 22,
                    color: themeModel.currentTheme.canvasColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  debugPrint('Amazing!');
                                },
                                child: Text('Register',
                                    style: themeModel
                                        .currentTheme.textTheme.bodySmall),
                              ),
                              TextButton(
                                  onPressed: () {
                                    debugPrint('Nice!');
                                  },
                                  child: IconTheme(
                                      data: themeModel.currentTheme.iconTheme,
                                      child: const Icon(Icons.login)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Image.asset('assets/images/footer.png'),
                ),
              ],
            ),
            const Text('© 2023 Recipy. All rights reserved.',
                style: TextStyle(
                  color: Color.fromARGB(60, 255, 255, 255),
                ))
          ],
        ));
  }
}
