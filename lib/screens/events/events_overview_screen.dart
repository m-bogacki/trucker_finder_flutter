import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/widgets/events/event_bottom_modal_sheet.dart';
import 'package:trucker_finder/widgets/events/event_card.dart';
import '../../providers/logged_user_provider.dart';
import '../../providers/events_provider.dart';
import '../../helpers/theme_helpers.dart';
import '../../providers/users_provider.dart';
import '../../widgets/events/users_events_boss_view.dart';

class EventsOverviewScreen extends StatelessWidget {
  static const routeName = '/events';

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<LoggedUser>(context, listen: false);
    final eventsProvider = Provider.of<Events>(context, listen: false);
    final usersProvider = Provider.of<Users>(context, listen: false);
    return FutureBuilder(
        future: eventsProvider.fetchAndSetEvents(loggedUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: ThemeHelpers.customSpinner,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Events'),
              actions: loggedUser.profile == 1
                  ? [
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) {
                                  return EventBottomModalSheet();
                                });
                          },
                          icon: const Icon(Icons.add))
                    ]
                  : [],
            ),
            body: loggedUser.profile == 2
                ? UsersEventsBossView(
                    usersProvider: usersProvider,
                  )
                : Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Consumer<Events>(
                      builder: (context, events, child) {
                        return ListView.builder(
                          itemCount: events.events.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 80,
                              child: Dismissible(
                                key: Key(events.events[index].id),
                                onDismissed: (direction) async {
                                  eventsProvider
                                      .deleteEvent(events.events[index].id);
                                },
                                child:
                                    EventCard(events.events[index], loggedUser),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          );
        });
  }
}
