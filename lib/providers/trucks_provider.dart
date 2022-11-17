import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import '../models/truck.dart';
import '../widgets/truck_bottom_modal.dart';

class Trucks with ChangeNotifier {
  String? authToken;

  Trucks(this.authToken);

  List<Truck> _trucks = [];

  List<Truck> get trucks {
    return [..._trucks];
  }

  List<Marker> _markers = [];

  List<Marker> get markers {
    return [..._markers];
  }

  void extractTrucksPositions(response) {
    List<Truck> trucks = [];
    final decodedResponse = json.decode(response.body);
    if (decodedResponse != null) {
      final trucksPositions =
          json.decode(decodedResponse["Data"]["Result"])["positionList"];
      for (var truckDevice in trucksPositions) {
        final truck = Truck(
          truckDevice['deviceId'],
          truckDevice['coordinate'],
          truckDevice['dateTime'],
          truckDevice['heading'],
          truckDevice['speed'],
          truckDevice['ignitionState'],
        );
        trucks.add(truck);
      }
      _trucks = trucks;
      createTruckMarkers();
    }
  }

  Future<void> getTrucksPositions() async {
    final response = await http.get(
        Uri.parse('http://api.truckerfinder.pl/api/Permissions/Positions'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "bearer $authToken"
        });
    extractTrucksPositions(response);
    notifyListeners();
  }

  Stream<void> getTrucksPositionsForMap() async* {
    yield* Stream.periodic(const Duration(seconds: 10), (_) async {
      final response = await http.get(
          Uri.parse('http://api.truckerfinder.pl/api/Permissions/Positions'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "bearer $authToken"
          });
      extractTrucksPositions(response);
      notifyListeners();
    });
  }

  void createTruckMarkers() {
    List<Marker> markers = [];
    for (var truck in trucks) {
      if (truck.coordinate != null) {
        double? lat = truck.coordinate!['latitude'];
        double? lng = truck.coordinate!['longitude'];
        Marker marker = Marker(
          key: Key(truck.deviceId!),
          width: 30.0,
          height: 30.0,
          point: LatLng(lat!, lng!),
          builder: (context) => GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 3,
                    blurRadius: 2,
                  )
                ],
                shape: BoxShape.circle,
                color: Color(ThemeHelpers.AccentColor),
              ),
              child: const Icon(
                FontAwesomeIcons.truckFront,
                color: Colors.black,
                size: 18,
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                context: context,
                builder: ((context) {
                  return TruckDetailsBottomModal(truck);
                }),
              );
            },
          ),
        );
        markers.add(marker);
      }
    }
    _markers = markers;
  }
}
