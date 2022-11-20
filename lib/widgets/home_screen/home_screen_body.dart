import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/widgets/ui_elements/avatar.dart';
import '../../providers/users_provider.dart';
import 'package:provider/provider.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building');
    return FutureBuilder(
        future: Provider.of<Users>(context, listen: false).fetchAndSetUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ThemeHelpers.customSpinner);
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Consumer<Users>(
                  builder: (context, usersProvider, _) {
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
                        itemCount: usersProvider.users.length,
                        itemBuilder: (context, index) {
                          final currentUser = usersProvider.users[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Column(
                              children: [
                                Avatar(30, currentUser),
                                const SizedBox(height: 8),
                                Text(
                                  currentUser.firstName,
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
                )
              ],
            ),
          );
        });
  }
}
