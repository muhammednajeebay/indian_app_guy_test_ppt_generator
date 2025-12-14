import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static const _grantedKey = 'permissions_granted';

  static Future<bool> ensureRequiredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyGranted = prefs.getBool(_grantedKey) == true;
    if (alreadyGranted) return true;
    var granted = true;
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      granted = status.isGranted;
    }
    if (granted) {
      await prefs.setBool(_grantedKey, true);
    }
    return granted;
  }
}
