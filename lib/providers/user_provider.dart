import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  String? Id;
  String? firstName;
  String? lastName;
  Uint8List? photo;

  User(this.Id, this.firstName, this.lastName);

  void setPhoto(base64Photo) {
    photo = base64Photo;
    notifyListeners();
  }
}
