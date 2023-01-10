import 'dart:convert';

import 'package:flutter/material.dart';
import '../../helpers/helper_methods.dart';
import '../../providers/logged_user_provider.dart';
import '../../providers/events_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../buttons/custom_button.dart';

class EventBottomModalSheet extends StatefulWidget {
  static final _form = GlobalKey<FormState>();

  @override
  State<EventBottomModalSheet> createState() => _EventBottomModalSheetState();
}

class _EventBottomModalSheetState extends State<EventBottomModalSheet> {
  Map<String, dynamic> eventData = {
    "UserId": '',
    "Title": '',
    "Description": '',
    "Number": '',
    "StartDate": DateTime.now().toIso8601String(),
    "EndDate": DateTime.now().toIso8601String(),
    "EventType": 0,
    "EventFiles": []
  };
  List imagesToShow = [];
  @override
  Widget build(BuildContext context) {
    final loggedUserId = Provider.of<LoggedUser>(context, listen: false).id;
    final eventsProvider = Provider.of<Events>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, top: 50),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Form(
        key: EventBottomModalSheet._form,
        child: Column(
          children: [
            DropdownButtonFormField(
              validator: (value) {
                if (value == null) {
                  return 'You need to select event type.';
                }
              },
              hint: Text('Event type'),
              items: HelperMethods.createDropdownFromEventType(),
              onChanged: (value) {
                setState(() {
                  eventData['EventType'] = value;
                });
              },
              onSaved: (value) {
                eventData['EventType'] = value;
              },
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title field can\'t be empty.';
                }
              },
              decoration: const InputDecoration(labelText: 'Title*'),
              onSaved: (value) {
                eventData['Title'] = value;
              },
            ),
            TextFormField(
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description field can\'t be empty.';
                }
              },
              decoration: const InputDecoration(
                labelText: 'Description*',
              ),
              onSaved: (value) {
                eventData['Description'] = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            eventData['EventType'] == 2 || eventData['EventType'] == 0
                ? Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: imagesToShow.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 80,
                              height: 80,
                              child: Image.memory(imagesToShow[index]),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          final imageAsBytes = await HelperMethods.getPicture(
                              ImageSource.camera);
                          if (imageAsBytes != null) {
                            setState(() {
                              imagesToShow.add(imageAsBytes);
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_camera)),
                    IconButton(
                      onPressed: () async {
                        final imageAsBytes =
                            await HelperMethods.getPicture(ImageSource.gallery);
                        if (imageAsBytes != null) {
                          setState(() {
                            imagesToShow.add(imageAsBytes);
                          });
                        }
                      },
                      icon: const Icon(Icons.photo_album),
                    ),
                  ])
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              action: () async {
                if (EventBottomModalSheet._form.currentState!.validate()) {
                  EventBottomModalSheet._form.currentState?.save();
                  try {
                    if (imagesToShow.isNotEmpty) {
                      for (var image in imagesToShow) {
                        int iterator = 1;
                        eventData['EventFiles'].add({
                          "FileName": "${eventData['Title']}$iterator",
                          "Base64File": {
                            "Base64String": base64Encode(image).toString()
                          }
                        });
                        iterator++;
                      }
                    }
                    eventData['UserId'] = loggedUserId;
                    await eventsProvider.addEvent(eventData);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Successfully added new event.',
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('$error')));
                    Navigator.pop(context);
                  }
                }
              },
              text: 'Add',
            )
          ],
        ),
      ),
    );
  }
}
