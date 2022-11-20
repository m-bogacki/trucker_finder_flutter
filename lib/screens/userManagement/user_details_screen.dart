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
  };

  @override
  Widget build(BuildContext context) {
    String editedUserId = ModalRoute.of(context)!.settings.arguments as String;
    final usersProvider = Provider.of<Users>(context, listen: false);
    User? currentUser = usersProvider.getUserById(editedUserId);
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Sorry I couldn\'t load this user)'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
      ),
      body: ChangeNotifierProvider<User>.value(
        value: currentUser,
        builder: (context, user) => Form(
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
                      child: Consumer<User>(
                          builder: (ctx, user, _) => Avatar(50, currentUser)),
                    ),
                    const SizedBox(width: 30),
                    Row(
                      children: [
                        ImageButton(
                          currentUser: currentUser,
                          imageSource: ImageSource.camera,
                          icon: Icons.camera_alt,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ImageButton(
                          currentUser: currentUser,
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
                  initialValue: currentUser.firstName,
                  onSaved: (value) => userData['FirstName'] = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  initialValue: currentUser.lastName,
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
                      userData['UserId'] = currentUser.id;
                      setState(() {
                        isLoading = true;
                      });
                      await usersProvider.updateUser(currentUser.id, userData);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Successfully saved ${currentUser.firstName} data',
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
