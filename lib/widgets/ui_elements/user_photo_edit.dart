import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/user_provider.dart';
import './rounded_gradient_border.dart';
import './avatar.dart';
import '../../helpers/theme_helpers.dart';
import '../buttons/image_button.dart';

class UserPhotoEditWidget extends StatefulWidget {
  UserPhotoEditWidget(this.user);
  User user;
  @override
  State<UserPhotoEditWidget> createState() => _UserPhotoEditWidgetState();
}

class _UserPhotoEditWidgetState extends State<UserPhotoEditWidget> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedGradientBorder(
          child: Avatar(50, user),
        ),
        user.photo == null || user.photo == ""
            ? const SizedBox(
                width: 30,
              )
            : Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(ThemeHelpers.primaryColor),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      user.photo = null;
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
        Row(
          children: [
            ImageButton(
              currentUser: user,
              imageSource: ImageSource.camera,
              icon: Icons.camera_alt,
            ),
            const SizedBox(
              width: 10,
            ),
            ImageButton(
              currentUser: user,
              imageSource: ImageSource.gallery,
              icon: Icons.image_search,
            ),
          ],
        )
      ],
    );
  }
}
