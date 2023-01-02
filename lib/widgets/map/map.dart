import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import '../../providers/trucks_provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../helpers/localization.dart';
import './trucks_markers_layer.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      try {
        final userId = Provider.of<LoggedUser>(context, listen: false).id;

        await Provider.of<Trucks>(context, listen: false).fetchTrucks(userId);
      } catch (error) {
        rethrow;
      }
    });
    setState(() {
      _isLoading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: Localization.determinePosition(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ThemeHelpers.customSpinner);
          }
          if (snapshot.error != null) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final latitude = snapshot.data?.latitude ?? 52.40;
          final longitude = snapshot.data?.longitude ?? 16.93;
          return FlutterMap(
            options: MapOptions(
              center: LatLng(latitude, longitude),
              zoom: 6.0,
              maxZoom: 18.0,
              minZoom: 4.0,
              enableScrollWheel: true,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              TrucksMarkersLayer(),
            ],
          );
        });
  }
}
