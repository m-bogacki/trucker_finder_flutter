import 'package:flutter/material.dart';
import '../models/truck.dart';

class TruckDetailsScreen extends StatelessWidget {
  static const routeName = '/truck-details';
  @override
  Widget build(BuildContext context) {
    var settings = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
