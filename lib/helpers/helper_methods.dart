import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constants.dart' as constants;
import '../constants/constants.dart';
import '../providers/user_provider.dart';

class HelperMethods {
  static Future<Uint8List?> getPicture(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: source);
      final imageAsBytes = await image?.readAsBytes();
      return imageAsBytes;
    } catch (err) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getStorageAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return null;
    }
    final Map<String, dynamic> decodedAuthData =
        await json.decode(prefs.getString('authData')!);
    return decodedAuthData;
  }

  static Future<Uint8List?> networkImageToBytes(String imageUrl) async {
    try {
      if (imageUrl.endsWith('api.TruckerFinder')) return Uint8List(0);
      final ByteData data =
          await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
      final Uint8List bytes = data.buffer.asUint8List();
      return bytes;
    } catch (error) {
      return null;
    }
  }

  static Future<Uint8List?> extractUserImage(dynamic userApiResponse) async {
    Uint8List? userPhoto;
    if (userApiResponse['FilePath'] != null &&
        userApiResponse['FilePath'] != '') {
      try {
        userPhoto = await networkImageToBytes(
            '${constants.appUrl}${userApiResponse['FilePath']}');
        return userPhoto;
      } catch (error) {
        return null;
      }
    }
    return null;
  }

  static bool isBoss(User user) {
    if (user.profile == Profiles.indexOf('Boss')) {
      return true;
    }
    if (user.profile == Profiles.indexOf('User')) {
      return false;
    }
    return false;
  }

  static String getTruckDirection(int heading) {
    String direction = '$heading°';
    if (heading <= 45 && heading >= 0 || heading >= 315 && heading <= 360)
      direction = 'North';
    if (heading > 45 && heading < 135) direction = 'East';
    if (heading >= 135 && heading <= 225) direction = 'South';
    if (heading > 225 && heading < 315) direction = 'West';

    return direction;
  }

  static List<DropdownMenuItem<String>> createDropdownFromUserList(
      List<User> userList) {
    List<DropdownMenuItem<String>> listToReturn = [];
    for (var user in userList) {
      listToReturn.add(
        DropdownMenuItem(
          child: Text('${user.firstName} ${user.lastName}'),
          value: user.id,
        ),
      );
    }
    return listToReturn;
  }
}
