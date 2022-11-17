import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/form_helpers.dart';
import '../../widgets/auth/auth_appBar.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/users_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../../helpers/theme_helpers.dart';

class AddUserScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  double passValidatorWidth = 0;
  bool _passValidated = false;
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
    "Profile": 2
  };

  Future<void> saveForm() async {
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Users>(context, listen: false)
        .createUser(registrationData);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar('Add user'),
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
                          if (value.length < 6 && value.length > 25) {
                            return 'Login must contain at least 6 characters.';
                          }
                          if (containSpecialCharacters(value, true)) {
                            return 'Login shouldn\'t contain any special characters.';
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
                          validator: (value) {
                            if (!_passValidated) {
                              return 'Password must meet with conditions below.';
                            }
                            if (value!.length > 40) {
                              return 'Password can have max 40 characters.';
                            }
                            return null;
                          },
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
                          _passValidated = true;
                        },
                        onFail: () {
                          _passValidated = false;
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email field can\'t be empty.';
                          }
                          if (containSpecialCharacters(value, false)) {
                            return 'Last shouldn\'t contain any special characters.';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'First name*'),
                        onSaved: (value) =>
                            registrationData['FirstName'] = value,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email field can\'t be empty.';
                          }
                          if (containSpecialCharacters(value, false)) {
                            return 'Last shouldn\'t contain any special characters.';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Last name*'),
                        onSaved: (value) =>
                            registrationData['LastName'] = value,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email field can\'t be empty.';
                          }
                          if (value.length != 9) {
                            return 'Phone number must consist of 9 digits';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Phone number*', hintText: '510222222'),
                        onSaved: (value) =>
                            registrationData['PhoneNumber'] = value,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            try {
                              await saveForm();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Sucessfully created ${registrationData['email']}')));
                              Navigator.pop(context);
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$error')));
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(300, 45)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(ThemeHelpers.PrimaryColor))),
                        child: const Text(
                          'Create',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
