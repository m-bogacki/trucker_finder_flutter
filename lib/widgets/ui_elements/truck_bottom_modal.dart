import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/truck.dart';

class TruckDetailsBottomModal extends StatelessWidget {
  const TruckDetailsBottomModal(this.truck);

  final Truck truck;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device ID: ${truck.deviceId}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Ignition State: ${truck.ignitionState}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Speed: ${truck.speed}km/h')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
