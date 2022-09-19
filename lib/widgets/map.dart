import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/trucks.dart';

import 'truck_marker.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  List<Marker>? markers;

  @override
  void initState() {
    Provider.of<Trucks>(context, listen: false).getTrucksPositions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trucks = Provider.of<Trucks>(context);
    return StreamBuilder<void>(
        stream: trucks.getTrucksPositionsForMap(),
        builder: (context, _) {
          markers = trucks.createTruckMarkers();
          return FlutterMap(
            options: MapOptions(
              center: LatLng(51.5, -0.09),
              zoom: 6.0,
              enableScrollWheel: true,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: markers ?? [],
              ),
            ],
          );
        });
  }
}
