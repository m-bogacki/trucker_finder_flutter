import 'package:flutter/material.dart';
import 'package:trucker_finder/screens/home_screen.dart';
import '../../widgets/auth/auth_appBar.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  Map<String, String?> _loginForm = {
    "EmailOrName": "",
    "Password": "SomeTest*45test",
  };

  var _isLoading = false;

  Future<void> saveForm() async {
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .authenticate(_loginForm, 'Login');
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _loginForm['EmailOrName'] = value?.toLowerCase(),
                        decoration:
                            const InputDecoration(labelText: 'Login/Email*'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (value) => _loginForm['Password'] = value,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password*'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            try {
                              await saveForm();
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$error')));
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
