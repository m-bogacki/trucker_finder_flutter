import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';

class TruckMarker {
  bool isFirstRender = false;

  static Future<List> getTrucks(String token) async {
    var url = Uri.parse('api.truckerfinder.pl/api/Permissions/Positions');
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "bearer $token"
    });
    var decodedResponse = jsonDecode(response.body);
    var positions = decodedResponse['positionList'];
    return positions;
  }

  static List<Marker> createTruckMarkers(dynamic trucksPositions) {
    List<Marker> markers = [];
    for (var position in trucksPositions) {
      var lat = position['coordinate']['latitude'];
      var long = position['coordinate']['longitude'];

      var marker = Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(lat, long),
        builder: (context) => GestureDetector(
          child: Container(
            child: Icon(FontAwesomeIcons.truckFront),
          ),
          onTap: () {
            print(lat);
          },
        ),
      );
      markers.add(marker);
    }
    return markers;
  }

  Stream<http.Response> getTrucksPositions(String token) async* {
    yield* Stream.periodic(Duration(seconds: 0), (_) {
      return http.get(
          Uri.parse('http://api.truckerfinder.pl/api/Permissions/Positions'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "bearer $token"
          });
    }).asyncMap((event) async => await event);
  }
}
