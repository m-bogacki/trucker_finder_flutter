import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/helper_methods.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/users_provider.dart';
import 'package:trucker_finder/widgets/buttons/custom_button.dart';
import 'package:trucker_finder/widgets/ui_elements/text_header.dart';
import '../../providers/trucks_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/ui_elements/avatar.dart';

class TruckDetailsScreen extends StatefulWidget {
  static const routeName = '/truck-details';

  @override
  State<TruckDetailsScreen> createState() => _TruckDetailsScreenState();
}

class _TruckDetailsScreenState extends State<TruckDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    int truckId = ModalRoute.of(context)?.settings.arguments as int;
    String? truckUserId;
    final usersProvider = Provider.of<Users>(context);
    final trucksProvider = Provider.of<Trucks>(context, listen: false);
    final editedTruck = trucksProvider.getTruckById(truckId);
    User? trucker;
    if (editedTruck.trucker != null) {
      trucker = usersProvider.getUserById(editedTruck.trucker!);
    }
    List<DropdownMenuItem<String>> options =
        HelperMethods.createDropdownFromUserList(
            usersProvider.getUsersByProfile('User'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Truck ${editedTruck.truckId}'),
      ),
      body: Column(
        children: [
          editedTruck.trucker != null && trucker != null
              ? Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: Color(ThemeHelpers.accentColor),
                      ),
                    ),
                    color: Color(ThemeHelpers.primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Avatar(40, trucker),
                            Text(
                              '${trucker.firstName} ${trucker.lastName}',
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 24,
                                color: Color(ThemeHelpers.thirdColor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHeader(
                  text: 'Register number: ${editedTruck.registerNumber}'),
              TextHeader(
                  text:
                      'Ignition state: ${editedTruck.ignitionState ? 'On' : 'Off'}'),
              TextHeader(text: 'Speed: ${editedTruck.speed}'),
              TextHeader(
                  text:
                      'Heading: ${HelperMethods.getTruckDirection(editedTruck.heading)}'),
              TextHeader(
                  text: 'Last update: ${DateTime.parse(editedTruck.dateTime)}'),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  DropdownButtonFormField(
                      validator: (value) {
                        if (value == null)
                          return 'You must select trucker to assign';
                      },
                      hint: Text('Select trucker'),
                      items: options,
                      onChanged: (value) {
                        truckUserId = value as String?;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        child: CustomButton(
                            action: () async {
                              if (_form.currentState!.validate()) {
                                try {
                                  _form.currentState?.save();
                                  await trucksProvider.assignTrucker(
                                      truckUserId!, truckId);
                                  options =
                                      HelperMethods.createDropdownFromUserList(
                                          usersProvider
                                              .getUsersByProfile('User'));
                                  setState(() {});
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Couldn\'t assign trucker. Check if user isn\'t assigned to other truck.'),
                                    ),
                                  );
                                }
                              }
                            },
                            text: ('Assign trucker')),
                      ),
                      editedTruck.trucker != null
                          ? IconButton(
                              onPressed: () async {
                                try {
                                  await trucksProvider.deleteTrucker(
                                      editedTruck.truckId,
                                      editedTruck.trucker!);
                                  options =
                                      HelperMethods.createDropdownFromUserList(
                                          usersProvider
                                              .getUsersByProfile('User'));
                                  setState(() {});
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Couldn\'t remove trucker.'),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.delete))
                          : SizedBox()
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
