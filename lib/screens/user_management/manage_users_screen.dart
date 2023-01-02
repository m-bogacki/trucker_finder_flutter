import 'package:flutter/material.dart';
import 'package:trucker_finder/screens/user_management/user_details_screen.dart';
import '../../helpers/theme_helpers.dart';
import '../../widgets/ui_elements/avatar.dart';
import '../../widgets/ui_elements/user_deletion_dialog.dart';
import '../../providers/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/screens/user_management/add_user_screen.dart';

class ManageUsersScreen extends StatefulWidget {
  static const routeName = '/manage-accounts';

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Users>(context, listen: false).fetchAndSetUsers();
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
        title: const Text('Manage accounts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddUserScreen.routeName);
            },
            icon: const Icon(Icons.person_add),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: ThemeHelpers.customSpinner,
            )
          : Consumer<Users>(
              builder: (ctx, usersProvider, _) => RefreshIndicator(
                onRefresh: () async {
                  usersProvider.fetchAndSetUsers();
                },
                child: ListView.builder(
                  itemCount: usersProvider.users.length,
                  itemBuilder: (ctx, index) {
                    final user = usersProvider.users[index];
                    return Dismissible(
                      key: Key(user.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (side) async {
                        return await showDialog(
                              barrierDismissible: false,
                              context: ctx,
                              builder: (context) {
                                return UserDeletionDialog(user: user);
                              },
                            ) ??
                            false;
                      },
                      child: Card(
                        child: ListTile(
                          leading: Avatar(23, user),
                          title: Text(
                              '${user.firstName ?? ''} ${user.lastName ?? ''}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, UserDetailsScreen.routeName,
                                  arguments: user.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
