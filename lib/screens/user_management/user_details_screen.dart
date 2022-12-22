import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/widgets/ui_elements/text_header.dart';
import '../../constants/constants.dart';
import '../../helpers/theme_helpers.dart';
import '../../providers/user_provider.dart';
import '../../providers/users_provider.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/ui_elements/user_photo_edit.dart';

class UserDetailsScreen extends StatefulWidget {
  static const routeName = '/user-details';

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final form = GlobalKey<FormState>();
  bool isLoading = false;

  final Map<String, dynamic> userData = {
    "UserId": "",
    "FirstName": "",
    "LastName": "",
    "RemovePhoto": false,
  };

  @override
  Widget build(BuildContext context) {
    String editedUserId = ModalRoute.of(context)?.settings.arguments as String;
    final usersProvider = Provider.of<Users>(context, listen: false);
    User? editedUser = usersProvider.getUserById(editedUserId);
    if (editedUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Couldn\'t find that user'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
      ),
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider<User>.value(
        value: editedUser,
        builder: (context, user) => isLoading
            ? const Center(
                child: ThemeHelpers.customSpinner,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<User>(
                      builder: (ctx, user, _) => UserPhotoEditWidget(user),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: form,
                      child: Column(children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                          initialValue: editedUser.firstName,
                          onSaved: (value) => userData['FirstName'] = value,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                          initialValue: editedUser.lastName,
                          onSaved: (value) => userData['LastName'] = value,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.grey),
                          decoration: const InputDecoration(labelText: 'Role'),
                          initialValue: Profiles[editedUser.profile],
                          enabled: false,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          text: 'Save',
                          action: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              form.currentState?.save();
                              userData['UserId'] = editedUser.id;
                              await usersProvider.updateUser(
                                  editedUser.id, userData);
                              print('test');

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Successfully saved ${editedUser.firstName} data',
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
                      ]),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
