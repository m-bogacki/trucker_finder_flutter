import 'package:flutter/material.dart';
import 'package:trucker_finder/screens/auth/welcome_screen.dart';
import 'package:trucker_finder/screens/trucks_map_screen.dart';
import '../widgets/map.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List widgets = [Center(child: Text('Home')), Map()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: widgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
