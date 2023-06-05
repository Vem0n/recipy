import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Create a curved animation
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return Container(
        color: themeModel.currentTheme.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 360,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: _animation.value,
                          child: Text(
                            style:
                                themeModel.currentTheme.textTheme.displayLarge,
                            'Nice to see you!',
                          ),
                        );
                      }),
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
                SizedBox(
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
