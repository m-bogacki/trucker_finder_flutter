import 'package:flutter/material.dart';
import '../../helpers/helper_methods.dart';
import '../../providers/logged_user_provider.dart';
import '../../providers/events_provider.dart';
import 'package:provider/provider.dart';

import '../buttons/custom_button.dart';

class EventBottomModalSheet extends StatelessWidget {
  static final _form = GlobalKey<FormState>();
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
  @override
  Widget build(BuildContext context) {
    final loggedUserId = Provider.of<LoggedUser>(context, listen: false).id;
    final eventsProvider = Provider.of<Events>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      height: 300,
      child: Form(
        key: _form,
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
                eventData['EventType'] = value;
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
              maxLines: 5,
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
            eventData['EventType'] == 2
                ? TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Number field can\'t be empty.';
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Number*'),
                    onChanged: (value) {
                      eventData['Number'] = value;
                    },
                    onSaved: (value) {
                      eventData['Number'] = value;
                    },
                  )
                : const SizedBox(),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              action: () async {
                if (_form.currentState!.validate()) {
                  _form.currentState?.save();
                  try {
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
