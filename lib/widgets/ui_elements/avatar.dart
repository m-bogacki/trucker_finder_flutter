import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';

class Avatar extends StatelessWidget {
  double radius;
  User user;
  Avatar(this.radius, this.user);
  @override
  Widget build(BuildContext context) {
    dynamic userImage = user.photo == null
        ? Image.asset(
            'assets/images/blank-avatar.png',
            gaplessPlayback: true,
            fit: BoxFit.cover,
          )
        : Image.memory(
            user.photo!,
            gaplessPlayback: true,
            fit: BoxFit.cover,
          );
    return ClipOval(
      child: SizedBox(width: radius * 2, height: radius * 2, child: userImage),
    );
  }
}
