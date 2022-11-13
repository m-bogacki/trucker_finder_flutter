import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/truck.dart';

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
            child: const Icon(FontAwesomeIcons.truckFront),
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

class TruckDetailsBottomModal extends StatelessWidget {
  const TruckDetailsBottomModal(this.truck);

  final Truck truck;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.memory(
                    base64Decode(
                        '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'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device ID: ${truck.deviceId}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Ignition State: ${truck.ignitionState}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Speed: ${truck.speed}km/h')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
