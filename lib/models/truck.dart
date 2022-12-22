class Truck {
  int truckId;
  String registerNumber;
  double latitude;
  double longitude;
  String dateTime;
  int heading;
  int speed;
  bool ignitionState;
  String? trucker;

  Truck(
    this.truckId,
    this.registerNumber,
    this.latitude,
    this.longitude,
    this.dateTime,
    this.heading,
    this.speed,
    this.ignitionState,
    this.trucker,
  );
}
