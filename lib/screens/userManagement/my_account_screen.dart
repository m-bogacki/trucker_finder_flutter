import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/providers/user_provider.dart';
import 'package:trucker_finder/providers/users_provider.dart';
import 'package:trucker_finder/widgets/ui_elements/avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucker_finder/widgets/buttons/custom_button.dart';
import '../../widgets/buttons/image_button.dart';
import '../../widgets/ui_elements/rounded_gradient_border.dart';

class MyAccountScreen extends StatefulWidget {
  static const routeName = '/user-details';

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
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
      ),
      body: Consumer<LoggedUser>(
        builder: (context, loggedUser, _) => Form(
          key: form,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedGradientBorder(
                      child: Avatar(50, loggedUser),
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        ImageButton(
                          currentUser: loggedUser,
                          imageSource: ImageSource.camera,
                          icon: Icons.camera_alt,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ImageButton(
                          currentUser: loggedUser,
                          imageSource: ImageSource.gallery,
                          icon: Icons.image_search,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name'),
                  initialValue: loggedUser.firstName,
                  onSaved: (value) => userData['FirstName'] = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  initialValue: loggedUser.lastName,
                  onSaved: (value) => userData['LastName'] = value,
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
                      await Provider.of<LoggedUser>(context, listen: false)
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
        ),
      ),
    );
  }
}
