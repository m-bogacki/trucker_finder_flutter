import 'dart:convert';
import 'dart:developer';
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
    if (_currentUser != null) return _currentUser;

    final authData = await HelperMethods.getStorageAuthData();
    if (authData == null) {
      return null;
    }
    final userId = authData['userId'];
    _currentUser = await fetchUserById(userId);

    return _currentUser;
  }

  Future<User?> fetchUserById(String userId) async {
    try {
      User? presentUser = getUserById(userId);
      if (presentUser != null) _users.remove(presentUser);
      Uri url = Uri.parse('${constants.appUrl}/User/$userId');
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);
      final fetchedUserData = decodedResponse['Data'];
      final fetchedUserId = fetchedUserData['UserPermissions'][0]['UserId'];
      User? user = User(fetchedUserId, fetchedUserData['FirstName'],
          fetchedUserData['LastName']);
      _users.add(user);
      return user;
    } catch (error) {
      rethrow;
    }
  }

  User? getUserById(String userId) {
    User? user;
    final matchedUsers = _users.where((user) => user.id == userId);
    if (matchedUsers.isEmpty) return null;
    user = matchedUsers.first;
    return user;
  }

  Future<void> fetchAndSetUsers() async {
    List<User> newUsers = [];
    final authData = await HelperMethods.getStorageAuthData();
    if (authData == null) return;
    final userId = authData['userId'];
    Uri url = Uri.parse('${constants.appUrl}/User/GetUserList/$userId');
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

  Future<void> deleteUser(String userId) async {
    try {
      final url = Uri.parse('http://api.truckerfinder.pl/api/User/$userId');
      final response = await http.delete(url, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });
      final extractedData = json.decode(response.body);
      if (extractedData['Errors'] != null) {
        throw HttpException(extractedData['Errors']['Message'][0]);
      }
      _users.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUser(
      String userId, Map<String, dynamic> userDetails) async {
    final user = getUserById(userId);
    if (user == null) return;
    try {
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
      _users.remove(user);
      _users.add(
        User(
          user.id,
          userDetails['FirstName'],
          userDetails['LastName'],
        ),
      );
    } catch (error) {
      log(error.toString());
      rethrow;
    }
    notifyListeners();
  }
}
