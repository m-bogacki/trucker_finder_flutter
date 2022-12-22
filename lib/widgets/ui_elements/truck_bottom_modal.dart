import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/widgets/ui_elements/avatar.dart';
import '../../models/truck.dart';
import '../../providers/user_provider.dart';
import '../../providers/users_provider.dart';

class TruckDetailsBottomModal extends StatelessWidget {
  const TruckDetailsBottomModal(this.truck);

  final Truck truck;

  @override
  Widget build(BuildContext context) {
    User? trucker;
    if (truck.trucker != null) {
      trucker = Provider.of<Users>(context, listen: false)
          .getUserById(truck.trucker!);
    }
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trucker != null
                    ? Avatar(60, trucker)
                    : SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Truck ID: ${truck.truckId}',
                      style: ThemeHelpers.truckDetailsTextStyle
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ignition State: ${truck.ignitionState ? 'On' : 'Off'}',
                      style: ThemeHelpers.truckDetailsTextStyle
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Speed: ${truck.speed}km/h',
                      style: ThemeHelpers.truckDetailsTextStyle
                          .copyWith(fontSize: 20),
                    )
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
