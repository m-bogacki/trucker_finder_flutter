import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';

class Trucks with ChangeNotifier {
  String? authToken;

  Trucks(this.authToken);

  List<dynamic> _truckPositions = [];

  List<dynamic> get truckPositions {
    return [..._truckPositions];
  }

  void extractTrucksPositions(response) {
    final decodedResponse = json.decode(response.body);
    if (decodedResponse != null) {
      final positions =
          json.decode(decodedResponse["Data"]["Result"])["positionList"];
      _truckPositions = positions;
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
    yield* Stream.periodic(Duration(seconds: 10), (_) async {
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

  List<Marker> createTruckMarkers() {
    List<Marker> markers = [];
    for (var position in _truckPositions) {
      double lat = position['coordinate']['latitude'];
      double long = position['coordinate']['longitude'];

      Marker marker = Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(lat, long),
        builder: (context) => GestureDetector(
          child: Icon(FontAwesomeIcons.truckFront),
          onTap: () {
            print(lat);
          },
        ),
      );
      markers.add(marker);
    }
    return markers;
  }
}
