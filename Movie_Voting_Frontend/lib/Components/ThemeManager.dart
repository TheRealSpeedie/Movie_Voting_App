import 'package:flutter/material.dart';
import 'package:movie_voting_frontend/Themes/darkTheme.dart';
import 'package:movie_voting_frontend/Themes/lightTheme.dart';

import '../API/ThemeAPICalls.dart';
import 'StorageManager.dart';

class ThemeNotifier with ChangeNotifier{
  final lightTheme = ThemeData(
    colorScheme: ligthColorScheme,
    useMaterial3: true,
  );
  final darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
  );
  late ThemeData  _themeData = darkTheme;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) async {
      var themeMode = value ?? 'dark';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else if(themeMode == "Costum"){
        int spaceIndex = themeMode.indexOf(' ');
        ColorScheme colorscheme = await GetThemeFromRaum(themeMode.substring(spaceIndex + 1));
        setTheme(colorscheme, themeMode.substring(spaceIndex + 1));
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  Future<ThemeData> checkMode(mode)async{
    switch(mode) {
      case "dark":
        return darkTheme;
      case "light":
        return lightTheme;
      default: return lightTheme;
    }
  }

  void setTheme(ColorScheme colorScheme, RaumID){
    _themeData = ThemeData( colorScheme: colorScheme);
    StorageManager.saveData('themeMode', 'Costum $RaumID');
  }
  void setMode(mode)async{
    _themeData = await checkMode(mode);
    StorageManager.saveData('themeMode', '$mode');
    notifyListeners();
  }
}