import 'package:flutter/material.dart';
import 'package:trucker_finder/widgets/auth/auth_appBar.dart';
import '../../helpers/theme_helpers.dart';

class PasswordResetScreen extends StatefulWidget {
  static const routeName = '/password-reset';

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  String? resetEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AuthAppBar('Reset password'),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Login field can\'t be empty.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      resetEmail = value;
                    },
                    decoration: const InputDecoration(
                        labelText: ''
                            'Email*'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () async {},
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(300, 45)),
                        backgroundColor: MaterialStateProperty.all(
                            Color(ThemeHelpers.primaryColor))),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
