import 'package:flutter/foundation.dart';

import 'myprefrences.dart';

class DarkThemeProvider with ChangeNotifier {
  MyPreferences darkThemePreference = MyPreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}