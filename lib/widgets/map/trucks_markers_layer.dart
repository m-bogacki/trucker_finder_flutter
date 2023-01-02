import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../providers/logged_user_provider.dart';
import '../../providers/trucks_provider.dart';

class TrucksMarkersLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<LoggedUser>(context, listen: false).id;
    return Consumer<Trucks>(
      builder: (ctx, trucksProvider, _) => StreamBuilder<void>(
        stream: trucksProvider.fetchTrucksPositionsForMap(userId),
        builder: (context, snapshot) {
          return MarkerLayer(
            markers: trucksProvider.markers,
          );
        },
      ),
    );
  }
}
