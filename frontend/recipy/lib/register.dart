import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();
    return Container(
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
          const SizedBox(height: 80,),
          SizedBox(
            height: 260,
            width: 400,
            child: Expanded(
              child: Center(
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
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                debugPrint("We're back!");
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
                                debugPrint('Registered');
                              },
                              child: Text(
                                'Sign up',
                                style:
                                    themeModel.currentTheme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40,),
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
    );
  }
}

