import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import '../constants/constants.dart';
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
    final sortedUsers = [..._users];
    sortedUsers.sort((a, b) => a.firstName!.compareTo(b.firstName!));
    return sortedUsers;
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
      Uri url = Uri.parse('${constants.appUrl}/api/User/$userId');
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);
      final fetchedUserData = decodedResponse['Data'];
      final fetchedUserId = fetchedUserData['Id'];
      Uint8List? userPhoto =
          await HelperMethods.extractUserImage(fetchedUserData);
      User? user = User(
        id: fetchedUserId,
        firstName: fetchedUserData['FirstName'],
        lastName: fetchedUserData['LastName'],
        theme: fetchedUserData['Theme'],
        language: fetchedUserData['Language'],
        profile: Profiles.indexOf(fetchedUserData['ProfileType']),
        photo: userPhoto!.isEmpty || fetchedUserData['FilePath'] == ''
            ? null
            : userPhoto,
      );
      _users.add(user);
      return user;
    } catch (error) {
      rethrow;
    }
  }

  User? getUserById(String userId) {
    User? user = _users.firstWhereOrNull((user) => user.id == userId);
    return user;
  }

  List<User> getUsersByProfile(String profile) {
    if (profile == 'Boss') {
      return users.where((user) => user.profile == 2).toList();
    }
    if (profile == 'User') {
      return users.where((user) => user.profile == 1).toList();
    }
    return users.where((user) => user.profile == 0).toList();
  }

  Future<void> fetchAndSetUsers() async {
    List<User> newUsers = [];
    try {
      final authData = await HelperMethods.getStorageAuthData();
      if (authData == null) return;
      final userId = authData['userId'];
      Uri url = Uri.parse('${constants.appUrl}/api/User/GetUserList/$userId');
      final response = await http.get(url);
      final responseData = jsonDecode(response.body)['Data'];
      for (var value in responseData) {
        Uint8List? userPhoto = await HelperMethods.extractUserImage(value);
        User user = User(
            id: value['Id'],
            firstName: value['FirstName'],
            lastName: value['LastName'],
            theme: value['Theme'],
            language: value['Language'],
            profile: Profiles.indexOf(value['ProfileType']),
            photo: userPhoto == null || value['FilePath'] == ''
                ? null
                : userPhoto);
        newUsers.add(user);
      }
      _users = newUsers;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
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
      final fetchedUserId = fetchedUserData['Id'];
      _users.add(
        User(
            id: fetchedUserId,
            firstName: authenticateData['FirstName'],
            lastName: authenticateData['LastName'],
            theme: 0,
            language: authenticateData['Language'],
            profile: authenticateData['Profile']),
      );
      notifyListeners();
      return fetchedUserId;
    } catch (error) {
      log(error.toString());
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
    User? user = getUserById(userId);
    if (user == null) return;
    try {
      user = await user.updateUser(userDetails);
      _users.remove(user);
      _users.add(user);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
    notifyListeners();
  }
}
