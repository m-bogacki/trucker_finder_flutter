import 'package:trucker_finder/constants/constants.dart';

class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.number,
    this.localization,
    required this.user,
    required this.startDate,
    this.endDate,
    required this.eventType,
    this.eventFiles,
  });

  String id;
  String title;
  String description;
  String number;
  List<double>? localization;
  String user;
  DateTime startDate;
  DateTime? endDate;
  EventType eventType;
  List<Map<String, dynamic>>? eventFiles;
}
