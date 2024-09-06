import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_voting_frontend/models/Theme.dart';
import 'package:http/http.dart' as http;

import '../Components/ExceptionThrower.dart';

Future<ColorScheme> GetThemeFromRaum(String raumID) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/theme/raum/$raumID'));

  await ExceptionThrower(error: "Failed to get Theme from Raum")
      .CheckForException(response);
    return ToThemeData(response.body);

}

Future<DBTheme> CreateTheme(ColorScheme colorscheme, raumID) async {
  String brightvalue;
  if(colorscheme.brightness == Brightness.light){
    brightvalue = "light";
  }else{
    brightvalue = "dark";
  }
  var theme = DBTheme(
      brigthness: brightvalue,
      background: HexFromColorScheme(colorscheme.background),
      onBackground: HexFromColorScheme(colorscheme.onBackground),
      primary: HexFromColorScheme(colorscheme.primary),
      onPrimary: HexFromColorScheme(colorscheme.onPrimary),
      secondary: HexFromColorScheme(colorscheme.secondary),
      onSecondary: HexFromColorScheme(colorscheme.onSecondary),
      surface: HexFromColorScheme(colorscheme.surface),
      onSurface: HexFromColorScheme(colorscheme.onSurface),
      error: HexFromColorScheme(colorscheme.error),
      onError: HexFromColorScheme(colorscheme.onError),
      RaumId: raumID);
  final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/theme/'),
      body: jsonEncode(theme.toJson()),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to Create Theme")
      .CheckForException(response, expectedStatusCode:  201);
    return DBTheme.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

String HexFromColorScheme(color) {
  return color.value.toRadixString(16).substring(2);
}
