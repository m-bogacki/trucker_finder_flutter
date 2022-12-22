import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';

import '../../helpers/theme_helpers.dart';
import '../../constants/constants.dart';
import '../../providers/trucks_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/ui_elements/avatar.dart';
import '../../providers/users_provider.dart';

class TruckersHorizontalList extends StatelessWidget {
  const TruckersHorizontalList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);
    final trucksProvider =
        Provider.of<Trucks>(context, listen: false).getActiveTrucks();

    return Consumer<Users>(
      builder: (context, usersProvider, _) {
        List<User> usersToDisplay =
            usersProvider.users.where((user) => user.profile == 1).toList();
        if (loggedUser.profile == Profiles.indexOf('Boss')) {}

        return Container(
          padding: const EdgeInsets.only(top: 18),
          height: 120,
          decoration: const BoxDecoration(
            color: Color(ThemeHelpers.primaryColor),
            border: Border(
              bottom: BorderSide(
                width: 3,
                color: Color(ThemeHelpers.accentColor),
              ),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 30.0,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: usersToDisplay.length,
            itemBuilder: (context, index) {
              final currentUser = usersToDisplay[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Avatar(30, currentUser),
                    const SizedBox(height: 8),
                    Text(
                      '${currentUser.firstName} ${currentUser.lastName}' ?? '',
                      style: const TextStyle(
                          color: Color(ThemeHelpers.thirdColor),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: 0.5),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
