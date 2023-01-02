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
    return Container(
        color: Color(ThemeHelpers.primaryColor),
        height: trucker != null ? 250 : 180,
        child: Column(
          children: [
            trucker != null
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration:
                        ThemeHelpers.AccentColorUnderlineBoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Avatar(25, trucker),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              '${trucker.firstName} ${trucker.lastName}',
                              style:
                                  ThemeHelpers.truckDetailsTextStyle.copyWith(
                                fontSize: 25,
                                color: const Color(ThemeHelpers.thirdColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 20,
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Truck ID: ${truck.truckId}',
                  style:
                      ThemeHelpers.truckDetailsTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Register number: ${truck.registerNumber}',
                  style:
                      ThemeHelpers.truckDetailsTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Ignition State: ${truck.ignitionState ? 'On' : 'Off'}',
                  style:
                      ThemeHelpers.truckDetailsTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Speed: ${truck.speed}km/h',
                  style:
                      ThemeHelpers.truckDetailsTextStyle.copyWith(fontSize: 20),
                )
              ],
            )
          ],
        ));
  }
}
