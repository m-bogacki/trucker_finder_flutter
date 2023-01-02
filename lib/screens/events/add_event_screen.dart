import 'package:flutter/material.dart';
import 'package:trucker_finder/helpers/helper_methods.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/widgets/buttons/custom_button.dart';
import 'package:provider/provider.dart';
import '../../providers/events_provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);
  static const routeName = '/add-event';

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _form = GlobalKey<FormState>();
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
    final eventsProvider = Provider.of<Events>(context, listen: false);
    final loggedUserId = Provider.of<LoggedUser>(context, listen: false).id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add event'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title field can\'t be empty.';
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Title*'),
                  onChanged: (value) {
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
                  onChanged: (value) {
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
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  action: () async {
                    if (_form.currentState!.validate()) {
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
        ),
      ),
    );
  }
}
