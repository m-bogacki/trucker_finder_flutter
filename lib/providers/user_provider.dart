import 'dart:typed_data';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String id;
  String firstName;
  String lastName;
  Uint8List? photo;

  User(this.id, this.firstName, this.lastName);

  void setPhoto(base64Photo) {
    photo = base64Photo;
    notifyListeners();
  }
}
