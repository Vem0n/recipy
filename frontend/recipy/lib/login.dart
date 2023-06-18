import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_structures.dart';
import 'fetcher.dart';
import 'theme.dart';

class LoginPage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const LoginPage({Key? key, required this.updateIndex}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    );

    final tween = Tween<double>(begin: -200, end: 0);

    _animation = tween.animate(curvedAnimation);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void loginHandler() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    LoginData data = LoginData(
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      final response = await Fetcher.post(
        'http://10.0.2.2:8080',
        '/auth/login',
        data,
      );

      if (response.statusCode == 200) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            duration: Duration(seconds: 2),
          ),
        );
        widget.updateIndex(1);
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Login failed: ${response.body}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return SingleChildScrollView(
      child: Container(
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
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _animation.value),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 12.8,
                                      offset: const Offset(0, 17))
                                ]),
                            child: Text(
                              'Nice to see you!',
                              style: themeModel
                                  .currentTheme.textTheme.displayLarge,
                            ),
                          ),
                        );
                      },
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
                                    widget.updateIndex(4);
                                    debugPrint('Amazing!');
                                  },
                                  child: Text('Register',
                                      style: themeModel
                                          .currentTheme.textTheme.bodySmall),
                                ),
                                TextButton(
                                    onPressed: () {
                                      loginHandler();
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
          )),
    );
  }
}
