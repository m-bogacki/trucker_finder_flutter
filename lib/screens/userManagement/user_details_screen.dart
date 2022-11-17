import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/user_provider.dart';
import 'package:trucker_finder/providers/users_provider.dart';
import 'package:trucker_finder/widgets/auth/avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucker_finder/widgets/custom_button.dart';
import '../../widgets/image_button.dart';
import '../../widgets/rounded_gradient_border.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
      ),
      body: FutureBuilder(
        future: Provider.of<Users>(context, listen: false)
            .getUserById(editedUserId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final currentUser = snapshot.data as User;

          return ChangeNotifierProvider<User>.value(
            value: currentUser,
            child: Form(
              key: form,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedGradientBorder(
                          child: Avatar(50),
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
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
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
                          await currentUser.updateUser(userData);
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
          );
        },
      ),
    );
  }
}
