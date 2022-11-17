import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/trucks_provider.dart';
import 'package:geolocator/geolocator.dart';
import '../helpers/localization.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  bool _isLoading = false;
  Position? position;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Trucks>(context, listen: false).getTrucksPositions();
      position = await Localization.determinePosition();
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
            return const Center(child: CircularProgressIndicator());
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

class TrucksMarkersLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Trucks>(
      builder: (ctx, trucksProvider, _) => StreamBuilder<void>(
        stream: trucksProvider.getTrucksPositionsForMap(),
        builder: (context, snapshot) {
          return MarkerLayer(
            markers: trucksProvider.markers,
          );
        },
      ),
    );
  }
}
