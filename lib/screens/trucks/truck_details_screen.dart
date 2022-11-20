import 'package:flutter/material.dart';
import '../../models/truck.dart';

class TruckDetailsScreen extends StatelessWidget {
  static const routeName = '/truck-details';

  const TruckDetailsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var settings = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
