import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import './login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Image(image: AssetImage('assets/images/logo-text.png')),
              const Text(
                'Locate your fleet',
                style: TextStyle(fontSize: 18),
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(300, 45)),
                        backgroundColor: MaterialStateProperty.all(
                            const Color(ThemeColors.PrimaryColor))),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
