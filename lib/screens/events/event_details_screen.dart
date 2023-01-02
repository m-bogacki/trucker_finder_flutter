import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/widgets/events/event_icon.dart';
import 'package:trucker_finder/widgets/ui_elements/text_header.dart';
import '../../providers/events_provider.dart';
import 'package:latlong2/latlong.dart';

class EventDetailsScreen extends StatelessWidget {
  static const routeName = '/event-details';

  @override
  Widget build(BuildContext context) {
    String eventId = ModalRoute.of(context)?.settings.arguments as String;
    final event = Provider.of<Events>(context, listen: false).getEvent(eventId);
    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Sorry we couldn\'t find informations about this event '),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: ThemeHelpers.AccentColorUnderlineBoxDecoration(),
              padding: EdgeInsets.only(left: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${event.description}',
                    style: const TextStyle(
                      color: Color(ThemeHelpers.thirdColor),
                      fontSize: 22,
                    ),
                  ),
                  event.number != ''
                      ? Text(
                          'Number: ${event.number}',
                          style: const TextStyle(
                            color: Color(ThemeHelpers.thirdColor),
                            fontSize: 22,
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    'Start date: ${DateFormat('d MMM yyyy HH:mm').format(event.startDate).toString()}',
                    style: const TextStyle(
                      color: Color(ThemeHelpers.thirdColor),
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Event type: ',
                        style: const TextStyle(
                          color: Color(ThemeHelpers.thirdColor),
                          fontSize: 22,
                        ),
                      ),
                      EventIcon(event.eventType),
                      Text(
                        event.eventType.name,
                        style: const TextStyle(
                          color: Color(ThemeHelpers.thirdColor),
                          fontSize: 22,
                        ),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: ThemeHelpers.AccentColorUnderlineBoxDecoration()
                .copyWith(border: const Border.fromBorderSide(BorderSide.none)),
            height: 400,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(event.localization![0], event.localization![1]),
                zoom: 10.0,
                maxZoom: 18.0,
                minZoom: 10.0,
                enableScrollWheel: true,
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      key: Key(eventId),
                      width: 30.0,
                      height: 30.0,
                      point: LatLng(
                          event.localization![0], event.localization![1]),
                      builder: (context) => GestureDetector(
                        child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 3,
                                  blurRadius: 2,
                                )
                              ],
                              shape: BoxShape.circle,
                              color: Color(ThemeHelpers.primaryColor),
                            ),
                            child: EventIcon(event.eventType)),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
