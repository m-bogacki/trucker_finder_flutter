import 'package:flutter/material.dart';
import 'package:trucker_finder/providers/user_provider.dart';
import '../../providers/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/screens/auth/addUser_screen.dart';

class AccountsScreen extends StatefulWidget {
  static const routeName = '/manage-accounts';

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Users>(context, listen: false).fetchAndSetUsers();
    });
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage accounts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddUserScreen.routeName);
            },
            icon: Icon(Icons.person_add),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Users>(
              builder: (ctx, usersProvider, _) => ListView.builder(
                  itemCount: usersProvider.users.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: ListTile(
                        title: Text(usersProvider.users[index].lastName!),
                        leading: Text(usersProvider.users[index].firstName!),
                      ),
                    );
                  }),
            ),
    );
  }
}
