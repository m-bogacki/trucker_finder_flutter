import 'package:trucker_finder/constants/constants.dart';

class Event {
  Event({
    required this.title,
    required this.description,
    required this.number,
    required this.startDate,
    this.endDate,
    required this.eventType,
    this.eventFiles,
  });

  String title;
  String description;
  String number;
  DateTime startDate;
  DateTime? endDate;
  EventType eventType;
  List<Map<String, dynamic>>? eventFiles;
}
