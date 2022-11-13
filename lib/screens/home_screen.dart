import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import '../widgets/map.dart';
import '../widgets/app_drawer.dart';
import '../providers/users_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/auth/avatar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  User? _currentUser;
  List widgets = [
    const Center(
      child: Text("test"),
    ),
    Map(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Users>(context, listen: false);
    return FutureBuilder(
        future: userProvider.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          _currentUser = snapshot.data as User?;
          return ChangeNotifierProvider<User>.value(
            value: _currentUser!,
            child: Scaffold(
              appBar: AppBar(
                title: Consumer<User>(
                  builder: (ctx, user, _) => Text(_currentIndex == 0
                      ? 'Hello ${user.firstName}'
                      : 'Your trucks'),
                ),
                centerTitle: false,
                actions: [
                  Avatar(23),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              body: widgets[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                fixedColor: const Color(ThemeColors.PrimaryColor),
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                  ),
                  BottomNavigationBarItem(
                    label: 'Map',
                    icon: Icon(Icons.map_outlined),
                    activeIcon: Icon(Icons.map),
                  ),
                ],
              ),
              drawer: AppDrawer(),
            ),
          );
        });
  }
}
