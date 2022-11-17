import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../helpers/theme_helpers.dart';
import '../helpers/helper_methods.dart';

class ImageButton extends StatelessWidget {
  const ImageButton(
      {required this.currentUser,
      required this.imageSource,
      required this.icon});

  final User currentUser;
  final ImageSource imageSource;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(ThemeHelpers.PrimaryColor),
      ),
      child: IconButton(
        onPressed: () async {
          final imageAsBytes = await HelperMethods.getPicture(imageSource);
          if (imageAsBytes != null) {
            currentUser.setPhoto(imageAsBytes);
          }
        },
        icon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
