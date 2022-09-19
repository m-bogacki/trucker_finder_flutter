import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home page'),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name == '/') {
                return null;
              } else {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
