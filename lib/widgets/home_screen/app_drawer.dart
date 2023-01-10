import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/helper_methods.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/screens/events/events_overview_screen.dart';
import 'package:trucker_finder/screens/trucks/manage_trucks_screen.dart';
import 'package:trucker_finder/screens/user_management/manage_users_screen.dart';
import 'package:trucker_finder/screens/user_management/my_account_screen.dart';

import '../../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoggedUser>(
      builder: (ctx, loggedUser, _) => Drawer(
        child: ListView(
          dragStartBehavior: DragStartBehavior.down,
          children: [
            ListTile(
              leading: const Icon(FontAwesomeIcons.truck),
              title: loggedUser.profile == 2
                  ? const Text('Trucks')
                  : const Text('My Truck'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ManageTrucksScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Events'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, EventsOverviewScreen.routeName);
              },
            ),
            loggedUser.profile == 2
                ? ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text('Manage accounts'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ManageUsersScreen.routeName);
                    },
                    enabled: HelperMethods.isBoss(loggedUser),
                  )
                : const SizedBox(),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('My account'),
              onTap: () async {
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MyAccountScreen.routeName);
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
