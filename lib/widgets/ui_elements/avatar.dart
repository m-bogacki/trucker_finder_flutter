import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';

class Avatar extends StatelessWidget {
  double radius;
  User user;
  Avatar(@required this.radius, @required this.user);
  @override
  Widget build(BuildContext context) {
    dynamic userImage = user.photo == null
        ? const AssetImage('assets/images/blank-avatar.png')
        : MemoryImage(user.photo!);
    return CircleAvatar(radius: radius, backgroundImage: userImage);
  }
}
