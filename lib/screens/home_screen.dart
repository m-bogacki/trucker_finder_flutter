import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/providers/user_provider.dart';
import 'package:trucker_finder/widgets/home_screen/home_screen_body.dart';
import '../widgets/map/map.dart';
import '../widgets/ui_elements/app_drawer.dart';
import '../widgets/ui_elements/avatar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  int _currentIndex = 0;
  List<Widget> widgets = [
    HomeScreenBody(),
    Map(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LoggedUser>(builder: (ctx, user, _) {
          return Text(
              _currentIndex == 0 ? 'Hello ${user.firstName}' : 'Your trucks');
        }),
        centerTitle: false,
        actions: [
          Consumer<LoggedUser>(
              builder: (ctx, user, _) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Avatar(24, user),
                  )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: IndexedStack(
          index: _currentIndex,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: widgets),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color(ThemeHelpers.primaryColor),
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
    );
  }
}
