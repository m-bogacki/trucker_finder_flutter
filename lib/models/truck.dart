import 'package:flutter/material.dart';

class Truck {
  String? deviceId;
  Map<String, dynamic>? coordinate;
  Map<String, dynamic>? dateTime;
  int? heading;
  int? speed;
  String? ignitionState;

  Truck(
    this.deviceId,
    this.coordinate,
    this.dateTime,
    this.heading,
    this.speed,
    this.ignitionState,
  );
}
