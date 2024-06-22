import 'package:shared_preferences/shared_preferences.dart';

class KtpData {
  static const String _imagePathKey = 'ktp_image_path';
  static const String _imageBase64Key = 'ktp_image_base64';

  // Save image path for mobile
  static Future<void> saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, path);
  }

  // Get image path for mobile
  static Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imagePathKey);
  }

  // Save base64 image for web
  static Future<void> saveImageBase64(String base64) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageBase64Key, base64);
  }

  // Get base64 image for web
  static Future<String?> getImageBase64() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageBase64Key);
  }
}
