import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/constants.dart';

class EventIcon extends StatelessWidget {
  EventIcon(this.eventType);

  EventType eventType;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    switch (eventType) {
      case EventType.Accident:
        icon = const Icon(
          Icons.car_crash_outlined,
          color: Colors.orangeAccent,
        );
        break;
      case EventType.Break:
        icon = const Icon(
          Icons.free_breakfast_outlined,
          color: Colors.blueAccent,
        );
        break;
      case EventType.InvoicePurchase:
        icon = const Icon(
          Icons.monetization_on_outlined,
          color: Colors.green,
        );
        break;
      case EventType.StartRoute:
        icon = const Icon(Icons.flag, color: Colors.lightGreen);
        break;
      case EventType.EndRoute:
        icon = const Icon(
          Icons.flag,
          color: Colors.red,
        );
        break;
      default:
        icon = const Icon(FontAwesomeIcons.question);
    }
    return icon;
  }
}
