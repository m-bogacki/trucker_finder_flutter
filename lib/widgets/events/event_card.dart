import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/screens/events/event_details_screen.dart';
import 'package:trucker_finder/widgets/events/event_icon.dart';
import '../../models/event.dart';
import '../../providers/user_provider.dart';

class EventCard extends StatelessWidget {
  EventCard(this.event, this.user);
  Event event;
  User? user;

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(EventDetailsScreen.routeName, arguments: event.id);
      },
      child: Card(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: EventIcon(event.eventType),
            ),
            Expanded(
              child: Text(
                event.title,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: user != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM yyyy HH:mm').format(event.startDate),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                loggedUser.profile == 2 && user != null
                    ? Text(
                        '${user?.firstName} ${user?.lastName}',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      )),
    );
  }
}
