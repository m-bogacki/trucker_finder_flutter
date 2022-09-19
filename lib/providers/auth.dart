import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> authenticate(
      Map<String, dynamic> authenticateData, String authForm) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final url =
          Uri.parse('http://api.truckerfinder.pl/api/Identity/$authForm');
      final response = await http.post(url,
          body: json.encode(authenticateData),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      final extractedData = json.decode(response.body);
      if (extractedData['Errors'] != null) {
        print(extractedData['Errors']);
        throw HttpException(extractedData['Errors']['Message'][0]);
      }
      print(extractedData);
      if (authForm == 'Login') {
        _token = extractedData['Data']['Jwt'];
        _expiryDate = DateTime.now().add(
          Duration(
            milliseconds: extractedData['Data']['ExpireTimeInMs'],
          ),
        );
        await prefs.setString(
          'authData',
          json.encode(
            {
              "token": _token,
              "expiryDate": _expiryDate?.toIso8601String(),
            },
          ),
        );
      }
      notifyListeners();
    } catch (error) {
      print('Auth Provider $error');
      throw error;
    }
  }

  Future<void> logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    notifyListeners();
  }
}
