import 'dart:typed_data';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class HelperMethods {
  static Future<Uint8List?> getPicture(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: source);
      final imageAsBytes = await image?.readAsBytes();
      return imageAsBytes;
    } catch (err) {
      throw err;
    }
  }

  static Future<Map<String, dynamic>?> getStorageAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return null;
    }
    return await json.decode(prefs.getString('authData')!)
        as Map<String, dynamic>;
  }
}
