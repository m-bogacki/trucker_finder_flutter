import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/screens/trucks/manage_trucks_screen.dart';
import 'package:trucker_finder/screens/userManagement/manage_users_screen.dart';
import 'package:trucker_finder/screens/userManagement/my_account_screen.dart';
import '../../providers/user_provider.dart';

import '../../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => Drawer(
        child: ListView(
          dragStartBehavior: DragStartBehavior.down,
          children: [
            ListTile(
              leading: const Icon(FontAwesomeIcons.truck),
              title: const Text('Trucks'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ManageTrucksScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Manage accounts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ManageUsersScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('My account'),
              onTap: () async {
                User? currentUser =
                    Provider.of<LoggedUser>(context, listen: false);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAccountScreen()));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
