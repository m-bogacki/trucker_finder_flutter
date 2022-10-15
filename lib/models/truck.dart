import 'package:flutter/material.dart';

class Truck {
  String? deviceId;
  Map<String, double>? coordinate;
  Map<String, dynamic>? dateTime;
  int? heading;
  int? speed;
  String? ignitionState;

  Truck(
    this.deviceId,
    this.dateTime,
    this.heading,
    this.speed,
    this.ignitionState,
  );
}
