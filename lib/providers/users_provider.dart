import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import './user_provider.dart';
import '../helpers/helper_methods.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart' as constants;

class Users with ChangeNotifier {
  String? authToken;
  User? _currentUser;

  Users(this.authToken);
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<User?> getCurrentUser() async {
    final authData = await HelperMethods.getStorageAuthData();
    if (authData == null) {
      return null;
    }
    final userId = authData['userId'];
    _currentUser = _currentUser ?? await getUserById(userId);
    return _currentUser;
  }

  Future<User> getUserById(String userId) async {
    await fetchAndSetUsers();
    User user;
    try {
      user = _users.firstWhere((user) => user.Id == userId);
    } catch (error) {
      Uri url = Uri.parse('${constants.appUrl}/User/${userId}');
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);
      final fetchedUserData = decodedResponse['Data'];
      final fetchedUserId = fetchedUserData['UserPermissions'][0]['UserId'];
      user = User(fetchedUserId, fetchedUserData['FirstName'],
          fetchedUserData['LastName']);
    }
    return user;
  }

  Future<void> fetchAndSetUsers() async {
    List<User> newUsers = [];
    final authData = await HelperMethods.getStorageAuthData();
    if (authData == null) {
      return null;
    }
    final userId = authData['userId'];
    Uri url = Uri.parse('${constants.appUrl}/User/GetUserList/${userId}');
    final response = await http.get(url);
    final responseData = jsonDecode(response.body)['Data'];
    for (var value in responseData) {
      User user = User(value['Id'], value['FirstName'], value['LastName']);
      newUsers.add(user);
    }
    _users = newUsers;
    notifyListeners();
  }

  Future<void> createUser(Map<String, dynamic> authenticateData) async {
    try {
      final url =
          Uri.parse('http://api.truckerfinder.pl/api/Identity/Register');
      final response = await http.post(url,
          body: json.encode(authenticateData),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      final extractedData = json.decode(response.body);
      if (extractedData['Errors'] != null) {
        throw HttpException(extractedData['Errors']['Message'][0]);
      }
      final fetchedUserData = extractedData['Data'];
      final fetchedUserId = fetchedUserData['UserPermissions'][0]['UserId'];
      _users.add(User(
        fetchedUserId,
        authenticateData['FirstName'],
        authenticateData['LastName'],
      ));
      notifyListeners();
      return fetchedUserId;
    } catch (error) {
      print(error);
    }
  }
}
