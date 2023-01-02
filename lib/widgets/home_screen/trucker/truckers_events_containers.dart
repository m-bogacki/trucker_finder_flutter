import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/widgets/events/event_card.dart';
import '../../../helpers/theme_helpers.dart';
import '../../../providers/events_provider.dart';

class TruckerEventsContainers extends StatelessWidget {
  const TruckerEventsContainers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<Events>(context, listen: false);
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);

    return FutureBuilder(
        future: eventsProvider.fetchAndSetEvents(loggedUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 350,
              decoration: ThemeHelpers.AccentColorUnderlineBoxDecoration(),
              child: const Center(child: ThemeHelpers.customSpinner),
            );
          }
          return Consumer<Events>(builder: (context, events, child) {
            List<Widget> eventsToDisplay = [];
            for (var event in events.events.take(6)) {
              eventsToDisplay.add(
                Container(
                  margin: const EdgeInsets.all(10),
                  child: EventCard(event, loggedUser),
                ),
              );
            }
            return Container(
              height: 350,
              decoration: ThemeHelpers.AccentColorUnderlineBoxDecoration(),
              child: eventsToDisplay.isEmpty
                  ? const Center(
                      child: Text(
                        'You have no Events to display',
                        style: TextStyle(
                            color: Color(ThemeHelpers.thirdColor),
                            fontSize: 20),
                      ),
                    )
                  : GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.5, crossAxisCount: 2),
                      children: eventsToDisplay),
            );
          });
        });
  }
}
