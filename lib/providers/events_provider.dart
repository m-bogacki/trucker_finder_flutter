import 'dart:convert';
import 'dart:developer';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:trucker_finder/constants/constants.dart';
import '../models/event.dart';
import 'package:http/http.dart' as http;

class Events extends ChangeNotifier {
  Events(this.authToken);
  String? authToken;

  List<Event> _events = [];

  List<Event> get events {
    final eventsToDisplay = [..._events];
    eventsToDisplay.sort(
      (a, b) => b.startDate.compareTo(a.startDate),
    );
    return [...eventsToDisplay];
  }

  Future<void> fetchAndSetEvents(String userId) async {
    List<Event> eventsToSet = [];
    try {
      final response = await http.get(
          Uri.parse('http://api.truckerfinder.pl/api/Event/ByUserId/$userId'),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "bearer $authToken"
          });
      final jsonResponse = jsonDecode(response.body)['Data'];
      for (var value in jsonResponse) {
        final event = Event(
          id: value['Id'],
          title: value['Title'],
          description: value['Description'],
          number: value['Number'],
          eventType: EventType.values.elementAt(value['EventType']),
          user: value['UserId'],
          localization: [value['Latitude'], value['Longitude']],
          startDate: DateTime.parse(value['StartDate']),
          endDate: DateTime.parse(value['EndDate']),
        );
        eventsToSet.add(event);
      }
      _events = eventsToSet;
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Event? getEvent(String eventId) {
    return events.firstWhereOrNull((event) => event.id == eventId);
  }

  Future<void> addEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await http.post(
          Uri.parse('http://api.truckerfinder.pl/api/Event'),
          body: json.encode(eventData),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "bearer $authToken"
          });
      await fetchAndSetEvents(eventData['UserId']);
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      final event = getEvent(eventId);
      if (event == null) return;
      final response = await http.delete(
          Uri.parse('http://api.truckerfinder.pl/api/Event'),
          body: json.encode({"EventId": eventId}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "bearer $authToken"
          });
      _events.remove(event);
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }
}
