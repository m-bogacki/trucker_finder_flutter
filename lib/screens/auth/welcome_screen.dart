import 'package:flutter/material.dart';
import './login_screen.dart';
import './register_screen.dart';

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
                        fixedSize: MaterialStateProperty.all(Size(300, 45)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlueAccent)),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.routeName);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(300, 45)),
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.black12, width: 1),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
