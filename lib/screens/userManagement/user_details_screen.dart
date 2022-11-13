import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/helper_methods.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/user_provider.dart';
import 'package:trucker_finder/providers/users_provider.dart';
import 'package:trucker_finder/widgets/auth/avatar.dart';
import 'package:image_picker/image_picker.dart';

class UserDetailsScreen extends StatelessWidget {
  static const routeName = '/user-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User details'),
      ),
      body: FutureBuilder(
        future: Provider.of<Users>(context, listen: false).getCurrentUser(),
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
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(ThemeColors.PrimaryColor),
                                Color(ThemeColors.AccentColor)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Avatar(50),
                        ),
                        const SizedBox(width: 30),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(ThemeColors.PrimaryColor),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final imageAsBytes =
                                      await HelperMethods.getPicture(
                                          ImageSource.camera);
                                  if (imageAsBytes != null) {
                                    currentUser.setPhoto(imageAsBytes!);
                                  }
                                },
                                icon: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(ThemeColors.PrimaryColor),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final imageAsBytes =
                                      await HelperMethods.getPicture(
                                          ImageSource.gallery);
                                  if (imageAsBytes != null) {
                                    currentUser.setPhoto(imageAsBytes);
                                  }
                                },
                                icon: const Icon(
                                  Icons.image_search,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
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
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      initialValue: currentUser.lastName,
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
