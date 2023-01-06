import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../helpers/helper_methods.dart';
import '../models/truck.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart' as constants;

class User with ChangeNotifier {
  String id;
  String? firstName;
  String? lastName;
  Uint8List? photo;
  int language;
  int theme;
  int profile;
  Truck? userTruck;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.language = 0,
    this.theme = 1,
    this.photo,
    this.profile = 0,
  });

  void setPhoto(base64Photo) {
    photo = base64Photo;
    notifyListeners();
  }

  Future<User> updateUser(Map<String, dynamic> userDetails) async {
    try {
      firstName = userDetails['FirstName'];
      lastName = userDetails['LastName'];
      if (photo != null) {
        userDetails.addAll({
          "Base64File": {
            "Base64String": base64Encode(photo!),
          },
        });
      }
      if (photo == null) userDetails['RemovePhoto'] = true;
      final url = Uri.parse('http://api.truckerfinder.pl/api/User/UpdateUser');
      final response = await http.put(url,
          body: json.encode(userDetails),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      final extractedData = json.decode(response.body);
      if (extractedData['Errors'] != null) {
        throw HttpException(extractedData['Errors']['Message'][0]);
      }
      notifyListeners();
      return this;
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  Future<void> refreshUserData() async {
    try {
      print('refreshing');
      Uri url = Uri.parse('${constants.appUrl}/api/User/$id');
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);
      final userData = decodedResponse['Data'];
      firstName = userData['FirstName'];
      lastName = userData['LastName'];
      profile = Profiles.indexOf(userData['ProfileType']);
      photo = await HelperMethods.extractUserImage(userData);
      language = userData['Language'];
      theme = userData['Theme'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
