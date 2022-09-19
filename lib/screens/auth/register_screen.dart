import 'dart:io';

import 'package:flutter/material.dart';
import '../../widgets/auth/auth_appBar.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../../helpers/form_helpers.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  double passValidatorWidth = 0;

  final _passwordController = TextEditingController();

  Map<String, dynamic> registrationData = {
    "Login": '',
    "Email": '',
    "Password": '',
    "PasswordCopy": '',
    "FirstName": '',
    "LastName": '',
    "PhoneNumber": '',
    "Language": 0,
    "Profile": 1
  };

  Future<void>? saveForm() async {
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .authenticate(registrationData, 'Register');
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar('Register'),
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
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Login field can\'t be empty.';
                          }
                          if (value.length < 6) {
                            return 'Login must contain at least 6 characters.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Login*'),
                        onSaved: (value) =>
                            registrationData['Login'] = value?.toLowerCase(),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email field can\'t be empty.';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'Email is not valid.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Email*'),
                        onSaved: (value) =>
                            registrationData['Email'] = value?.toLowerCase(),
                      ),
                      Focus(
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            setState(() {
                              passValidatorWidth = 140;
                            });
                          }
                          if (!hasFocus) {
                            setState(() {
                              passValidatorWidth = 0;
                            });
                          }
                        },
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password*',
                          ),
                          obscureText: true,
                          onSaved: (value) =>
                              registrationData['Password'] = value,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FlutterPwValidator(
                        controller: _passwordController,
                        minLength: 6,
                        uppercaseCharCount: 2,
                        numericCharCount: 3,
                        specialCharCount: 1,
                        width: 400,
                        height: passValidatorWidth,
                        onSuccess: () {
                          return null;
                        },
                        onFail: () {
                          return 'dsds';
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Password fields does not match';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Confirm password*'),
                        obscureText: true,
                        onSaved: (value) =>
                            registrationData['PasswordCopy'] = value,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'First name*'),
                        onSaved: (value) =>
                            registrationData['FirstName'] = value,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Last name*'),
                        onSaved: (value) =>
                            registrationData['LastName'] = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Phone number*',
                            hintText: '+48 510222222'),
                        onSaved: (value) =>
                            registrationData['PhoneNumber'] = value,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            try {
                              await saveForm();
                            } catch (error) {
                              print('Register Screen $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$error')));
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
