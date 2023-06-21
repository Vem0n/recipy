import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipy/config.dart';
import 'theme.dart';
import 'fetcher.dart';
import 'data_structures.dart';

class RegistrationPage extends StatefulWidget {
  final void Function(int newIndex) updateIndex;

  const RegistrationPage({Key? key, required this.updateIndex})
      : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

bool isEmail(TextEditingController emailController) {
  final email = emailController.text;
  const pattern =
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
  final regex = RegExp(pattern);
  return regex.hasMatch(email);
}

class _RegistrationPageState extends State<RegistrationPage> {
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  void registrationHandler() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final url = config.apiUrl;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (isEmail(emailController)) {
      RegistrationData data = RegistrationData(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );

      try {
        final response = await Fetcher.put(
          url,
          '/auth/signup',
          data,
        );

        if (response.statusCode == 200) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Registration successful'),
              duration: Duration(seconds: 2),
            ),
          );
          widget.updateIndex(3);
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${response.body}'),
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
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return SingleChildScrollView(
      child: Container(
        color: themeModel.currentTheme.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 90.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12.8,
                      offset: const Offset(0, 17),
                    ),
                  ],
                ),
                child: Text(
                  "Let's get cookin'!",
                  style: themeModel.currentTheme.textTheme.displayLarge,
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              height: 260,
              width: 400,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 22,
                color: themeModel.currentTheme.canvasColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.updateIndex(3);
                            },
                            child: Row(
                              children: [
                                IconTheme(
                                  data: themeModel.currentTheme.iconTheme,
                                  child: const Icon(Icons.arrow_back),
                                ),
                                Text(
                                  'Back',
                                  style: themeModel
                                      .currentTheme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              registrationHandler();
                            },
                            child: Text(
                              'Sign up',
                              style: themeModel
                                  .currentTheme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Image.asset('assets/images/footer.png'),
                ),
                const Text(
                  '© 2023 Recipy. All rights reserved.',
                  style: TextStyle(
                    color: Color.fromARGB(60, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
