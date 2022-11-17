import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trucker_finder/providers/user_provider.dart';
import 'package:trucker_finder/screens/auth/password_reset_screen.dart';
import '../../widgets/auth/auth_appBar.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../helpers/theme_helpers.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final Map<String, String?> _loginForm = {
    "EmailOrName": "",
    "Password": "SomeTest*45test",
  };

  var _isLoading = false;

  Future<void> saveForm() async {
    if (_form.currentState!.validate()) {
      try {
        _form.currentState?.save();
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false).login(_loginForm);
        setState(() {
          _isLoading = false;
        });
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar('Login'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
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
                        onSaved: (value) =>
                            _loginForm['EmailOrName'] = value?.toLowerCase(),
                        decoration: const InputDecoration(
                            labelText: ''
                                'Email*'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password field can\'t be empty.';
                          }
                          return null;
                        },
                        onSaved: (value) => _loginForm['Password'] = value,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password*'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () async {
                          await saveForm();
                        },
                        style: ThemeHelpers.buttonStyle,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, PasswordResetScreen.routeName);
                        },
                        child: Text('Forgot password?'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
