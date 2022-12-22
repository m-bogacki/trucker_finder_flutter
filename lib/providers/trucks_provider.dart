import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import '../models/truck.dart';
import '../widgets/ui_elements/truck_bottom_modal.dart';

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

  Truck getTruckById(int truckId) {
    final foundTruck = trucks.firstWhere((truck) => truck.truckId == truckId);
    return foundTruck;
  }

  void extractTrucks(response) {
    List<Truck> trucks = [];
    final decodedResponse = json.decode(response.body);
    if (decodedResponse != null) {
      final trucksPositions = decodedResponse["Data"];
      for (var truckDevice in trucksPositions) {
        final truck = Truck(
          truckDevice['TruckId'],
          truckDevice['RegisterNumber'],
          truckDevice['TruckDetails']['LastLatitude'],
          truckDevice['TruckDetails']['LastLongitude'],
          truckDevice['TruckDetails']['LastLocalizationDate'],
          truckDevice['TruckDetails']['Heading'],
          truckDevice['TruckDetails']['Speed'],
          truckDevice['TruckDetails']['IgnitionState'],
          truckDevice['User']?['Id'],
        );
        trucks.add(truck);
      }
      _trucks = trucks;
      createTruckMarkers();
    }
  }

  Future<void> fetchTrucks(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('http://api.truckerfinder.pl/api/Truck/$userId'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "bearer $authToken"
          });
      extractTrucks(response);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Stream<void> fetchTrucksPositionsForMap(String userId) async* {
    try {
      yield* Stream.periodic(const Duration(seconds: 60), (_) async {
        final response = await http.get(
            Uri.parse('http://api.truckerfinder.pl/api/Truck/$userId'),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": "bearer $authToken"
            });
        extractTrucks(response);
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
  }

  void createTruckMarkers() {
    List<Marker> markers = [];
    for (var truck in trucks) {
      double? lat = truck.latitude;
      double? lng = truck.longitude;
      Marker marker = Marker(
        key: Key(truck.truckId.toString()),
        width: 30.0,
        height: 30.0,
        point: LatLng(lat, lng),
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
              color: Color(ThemeHelpers.accentColor),
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
    _markers = markers;
  }

  Future<void> assignTrucker(Map<String, dynamic> truckerData) async {
    try {
      final response = await http.put(
          Uri.parse(
              'http://api.truckerfinder.pl/api/Truck/trucker?userId=${truckerData['userId']}&truckId=${truckerData['truckId']}'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if (response.statusCode != 200)
        throw HttpException('Couldn\'t assign trucker');
      final truck = getTruckById(truckerData['truckId']);
      truck.trucker = truckerData['userId'];
      trucks.remove(truck);
      trucks.add(truck);
      notifyListeners();
    } on HttpException {
      rethrow;
    }
  }

  Future<void> deleteTrucker(int truckId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://api.truckerfinder.pl/api/Truck/trucker?truckId=$truckId'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
      );
      if (response.statusCode != 200)
        throw HttpException('Couldn\'t update trucker');
      final truck = getTruckById(truckId);
      truck.trucker = null;
      trucks.remove(truck);
      trucks.add(truck);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Truck> getActiveTrucks() {
    final activeTrucks = trucks.where((truck) => truck.ignitionState).toList();
    return activeTrucks;
  }
}
