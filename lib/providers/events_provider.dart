import 'package:flutter/material.dart';
import '../models/event.dart';

class Events extends ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events {
    return [..._events];
  }
}
