import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/providers/trucks_provider.dart';
import 'package:trucker_finder/screens/trucks/truck_details_screen.dart';
import 'package:trucker_finder/widgets/ui_elements/avatar.dart';
import 'package:collection/collection.dart';

import '../../helpers/theme_helpers.dart';
import '../../providers/user_provider.dart';
import '../../providers/users_provider.dart';

class ManageTrucksScreen extends StatelessWidget {
  static const routeName = '/trucks';

  const ManageTrucksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trucksProvider = Provider.of<Trucks>(context, listen: false);
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);
    final usersProvider = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Trucks'),
      ),
      body: FutureBuilder(
        future: trucksProvider.fetchTrucks(loggedUser.id),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ThemeHelpers.customSpinner);
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error ocurred'),
              );
            } else {
              return Consumer<Trucks>(
                builder: (context, trucks, _) => ListView.builder(
                  itemCount: trucks.trucks.length,
                  itemBuilder: (ctx, i) {
                    User? truckUser;
                    if (trucks.trucks[i].trucker != null) {
                      truckUser =
                          usersProvider.getUserById(trucks.trucks[i].trucker!);
                      truckUser?.userTruck = trucks.trucks[i];
                    }
                    return Card(
                      child: Consumer<Trucks>(
                        builder: (context, trucks, _) {
                          return ListTile(
                            leading: truckUser != null
                                ? Avatar(25, truckUser)
                                : null,
                            title:
                                Text('Truck nr: ${trucks.trucks[i].truckId}'),
                            subtitle: truckUser != null
                                ? Text(
                                    'Trucker: ${truckUser.firstName} ${truckUser.lastName}')
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  TruckDetailsScreen.routeName,
                                  arguments: trucks.trucks[i].truckId,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
