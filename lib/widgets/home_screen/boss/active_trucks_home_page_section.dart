import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/users_provider.dart';
import '../../ui_elements/text_header.dart';
import '../../../providers/trucks_provider.dart';
import '../../../helpers/theme_helpers.dart';

class ActiveTrucksHomePageSection extends StatelessWidget {
  const ActiveTrucksHomePageSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Trucks>(
      builder: (context, trucks, child) {
        final activeTrucks = trucks.getActiveTrucks();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            TextHeader(
              text:
                  'Currently active trucks ${activeTrucks.length}/${trucks.trucks.length}',
            ),
            SizedBox(
              height: 263,
              child: activeTrucks.isEmpty
                  ? const Center(
                      child: Text('There are no active trucks.'),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: activeTrucks.length,
                      itemBuilder: (BuildContext ctx, index) {
                        final truck = activeTrucks[index];
                        User? trucker;
                        if (truck.trucker != null) {
                          trucker = Provider.of<Users>(context)
                              .getUserById(truck.trucker!);
                        }

                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0.2,
                                    color: Colors.grey.withOpacity(0.9),
                                    blurRadius: 7,
                                    offset: const Offset(0, 0))
                              ],
                              color: const Color(ThemeHelpers.thirdColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Truck ID: ${activeTrucks[index].truckId}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              trucker != null
                                  ? Text(
                                      'Trucker: ${trucker.firstName} ${trucker.lastName}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
