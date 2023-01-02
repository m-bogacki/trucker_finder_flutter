import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import '../../providers/users_provider.dart';
import '../../providers/events_provider.dart';
import '../../models/event.dart';
import 'event_card.dart';
import 'package:provider/provider.dart';

class UsersEventsBossView extends StatefulWidget {
  const UsersEventsBossView({
    Key? key,
    required this.usersProvider,
  }) : super(key: key);
  final Users usersProvider;

  @override
  State<UsersEventsBossView> createState() => _UsersEventsBossViewState();
}

class _UsersEventsBossViewState extends State<UsersEventsBossView> {
  TextEditingController searchFieldController = TextEditingController();
  List<Event> initEvents = [];
  List<Event> eventsToDisplay = [];
  bool isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      final loggedUser = Provider.of<LoggedUser>(context, listen: false);
      final eventsProvider = Provider.of<Events>(context, listen: false);
      await eventsProvider.fetchAndSetEvents(loggedUser.id);
      initEvents = eventsProvider.events;
      eventsToDisplay = initEvents;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: ThemeHelpers.customSpinner)
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchFieldController,
                  decoration: const InputDecoration(
                      hintText: 'Search by Title/Trucker'),
                  onChanged: (_) {
                    setState(() {
                      eventsToDisplay = initEvents
                          .where((event) =>
                              event.title.contains(searchFieldController.text))
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: eventsToDisplay.length,
                  itemBuilder: (context, index) {
                    final user = widget.usersProvider
                        .getUserById(eventsToDisplay[index].user);
                    return Container(
                        height: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 200,
                        child: EventCard(eventsToDisplay[index], user));
                  },
                ),
              ),
            ],
          );
  }
}
