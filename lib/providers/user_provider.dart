import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User with ChangeNotifier {
  String? id;
  String? firstName;
  String? lastName;
  Uint8List? photo;

  User(this.id, this.firstName, this.lastName);

  void setPhoto(base64Photo) {
    photo = base64Photo;
    notifyListeners();
  }

  Future<void> updateUser(userData) async {
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
