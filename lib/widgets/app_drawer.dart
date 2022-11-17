import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trucker_finder/screens/trucks_screen.dart';
import 'package:trucker_finder/screens/userManagement/manage_users_screen.dart';
import 'package:trucker_finder/screens/userManagement/user_details_screen.dart';
import '../providers/users_provider.dart';

import '../providers/auth_provider.dart';

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
                Navigator.pushNamed(context, TrucksScreen.routeName);
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
                final currentUser =
                    await Provider.of<Users>(context, listen: false)
                        .getCurrentUser();
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    UserDetailsScreen.routeName,
                    arguments: currentUser?.id,
                  );
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
