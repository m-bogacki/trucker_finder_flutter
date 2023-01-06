import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import '../../providers/logged_user_provider.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/ui_elements/user_photo_edit.dart';
import '../../helpers/helper_methods.dart';

class MyAccountScreen extends StatefulWidget {
  static const routeName = '/my-account';

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final form = GlobalKey<FormState>();
  bool isLoading = false;
  final Map<String, dynamic> userData = {
    "UserId": "",
    "FirstName": "",
    "LastName": "",
    "RemovePhoto": false,
  };

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<LoggedUser>(context, listen: false).refreshUserData();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
      ),
      body: isLoading
          ? const Center(
              child: ThemeHelpers.customSpinner,
            )
          : Consumer<LoggedUser>(
              builder: (context, loggedUser, _) {
                return Form(
                  key: form,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        UserPhotoEditWidget(loggedUser),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                          initialValue: loggedUser.firstName,
                          onSaved: (value) => userData['FirstName'] = value,
                          readOnly: !HelperMethods.isBoss(loggedUser),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                          initialValue: loggedUser.lastName,
                          onSaved: (value) => userData['LastName'] = value,
                          readOnly: !HelperMethods.isBoss(loggedUser),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          text: 'Save',
                          action: () async {
                            try {
                              form.currentState?.save();
                              userData['UserId'] = loggedUser.id;
                              setState(() {
                                isLoading = true;
                              });
                              await Provider.of<LoggedUser>(context,
                                      listen: false)
                                  .updateLoggedUser(userData);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Successfully saved ${loggedUser.firstName} data',
                                    ),
                                  ),
                                );
                              }
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.toString(),
                                  ),
                                ),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
