import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import '../home_screen/truckers_horizontal_list.dart';
import '../home_screen/active_trucks_home_page_section.dart';
import '../../providers/users_provider.dart';
import 'package:provider/provider.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);
    return FutureBuilder(
      future: Provider.of<Users>(context, listen: false).fetchAndSetUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ThemeHelpers.customSpinner);
        }
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const TruckersHorizontalList(),
                loggedUser.profile == 2
                    ? const ActiveTrucksHomePageSection()
                    : const SizedBox(
                        height: 20,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
