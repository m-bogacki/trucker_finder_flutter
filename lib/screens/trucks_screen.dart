import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/trucks_provider.dart';

class TrucksScreen extends StatelessWidget {
  static const routeName = '/trucks';

  @override
  Widget build(BuildContext context) {
    final trucksProvider = Provider.of<Trucks>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Trucks'),
      ),
      body: FutureBuilder(
        future: trucksProvider.getTrucksPositions(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error ocurred'),
              );
            } else {
              return ListView.builder(
                itemCount: trucksProvider.trucks.length,
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    title: Text(
                        'Device ID: ${trucksProvider.trucks[i].deviceId!}'),
                    onTap: () {},
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
