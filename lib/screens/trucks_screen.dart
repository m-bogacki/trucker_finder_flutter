import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/trucks_provider.dart';

class TrucksScreen extends StatelessWidget {
  static const routeName = '/trucks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Trucks'),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Trucks>(context, listen: false).getTrucksPositions(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error ocurred'),
                );
              } else {
                return Consumer<Trucks>(
                  builder: (context, trucksData, child) => ListView.builder(
                    itemCount: trucksData.trucks.length,
                    itemBuilder: (ctx, i) => Card(
                      child: ListTile(
                        title: Text(
                            'Device ID: ${trucksData.trucks[i].deviceId!}'),
                        onTap: () {},
                      ),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
