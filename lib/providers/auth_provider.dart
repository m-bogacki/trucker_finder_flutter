import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  LoggedUser? loggedUser;

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

  Future<void> login(Map<String, dynamic> loginData) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final url = Uri.parse('http://api.truckerfinder.pl/api/Identity/Login');
      final response = await http.post(url,
          body: json.encode(loginData),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      final extractedData = json.decode(response.body);
      if (extractedData['Errors'] != null) {
        throw HttpException(extractedData['Errors']['Message'][0]);
      }
      _token = extractedData['Data']['Jwt'];
      final jwtData = Jwt.parseJwt(_token!);
      loggedUser =
          LoggedUser(jwtData['Id'], jwtData['FirstName'], jwtData['LastName']);
      _userId = jwtData['Id'];
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
            "userId": _userId,
          },
        ),
      );
      notifyListeners();
      _autoLogout();
    } catch (error) {
      print('Auth Provider $error');
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    print('Trying');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return false;
    }
    final extractedAuthData =
        json.decode(prefs.getString('authData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedAuthData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedAuthData['token'];
    final jwtData = Jwt.parseJwt(_token!);
    loggedUser =
        LoggedUser(jwtData['Id'], jwtData['FirstName'], jwtData['LastName']);
    _userId = extractedAuthData['Id'];
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
    return true;
  }

  void logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }
}
