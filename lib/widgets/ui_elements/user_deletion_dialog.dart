import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import '../../providers/users_provider.dart';
import '../../helpers/theme_helpers.dart';
import 'package:provider/provider.dart';

class UserDeletionDialog extends StatelessWidget {
  const UserDeletionDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: SizedBox(
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Are you sure, you want to delete ${user.firstName} ${user.lastName}?',
                style: const TextStyle(fontSize: 16, letterSpacing: 0.8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    clipBehavior: Clip.hardEdge,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          width: 2.0, color: Color(ThemeHelpers.primaryColor)),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Color(ThemeHelpers.primaryColor),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Provider.of<Users>(context, listen: false)
                          .deleteUser(user.id!);
                      Navigator.pop(context);
                    },
                    clipBehavior: Clip.hardEdge,
                    style: TextButton.styleFrom(
                      backgroundColor: Color(ThemeHelpers.primaryColor),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
