
import 'package:flutter/cupertino.dart';
import 'package:launcher/main.dart';

class SettingsViewModel extends ChangeNotifier {
  bool get isDarkMode => sharedPreferences.getBool('isDarkMode') ?? false;

  void toggleDarkMode(bool value) async => sharedPreferences
      .setBool('isDarkMode', value)
      .then((_) => notifyListeners());

  changeWallpaper() {}
}
