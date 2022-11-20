import 'package:trucker_finder/providers/user_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoggedUser extends User {
  LoggedUser(String id, String firstName, String lastName)
      : super(id, firstName, lastName);

  Future<void> updateLoggedUser(userData) async {
    try {
      final url = Uri.parse('http://api.truckerfinder.pl/api/User/UpdateUser');
      final response = await http.put(url,
          body: json.encode(userData),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      final extractedData = json.decode(response.body);
      if (extractedData['Errors'] != null) {
        throw HttpException(extractedData['Errors']['Message'][0]);
      }
      firstName = userData['FirstName'];
      lastName = userData['LastName'];
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
