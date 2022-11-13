import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class Avatar extends StatelessWidget {
  double radius;

  Avatar(@required this.radius);
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, _) {
        return user.photo == null
            ? CircleAvatar(
                radius: radius,
                backgroundImage: AssetImage('assets/images/blank-avatar.png'))
            : CircleAvatar(
                radius: radius, backgroundImage: MemoryImage(user.photo!));
      },
    );
  }
}
