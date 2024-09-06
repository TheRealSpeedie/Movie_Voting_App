import 'dart:convert';

import 'package:flutter/material.dart';

class DBTheme {
  String brigthness;
  String background;
  String onBackground;
  String primary;
  String onPrimary;
  String secondary;
  String onSecondary;
  String surface;
  String onSurface;
  String error;
  String onError;
  String RaumId;

  DBTheme(
      {required this.brigthness,
      required this.background,
      required this.onBackground,
      required this.primary,
      required this.onPrimary,
      required this.secondary,
      required this.onSecondary,
      required this.surface,
      required this.onSurface,
      required this.error,
      required this.onError,
      required this.RaumId});

  factory DBTheme.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'brightness': String Brigthness,
        'background': String Background,
        'onBackground': String OnBackground,
        'primary': String Primary,
        'onPrimary': String OnPrimary,
        'secondary': String Secondary,
        'onSecondary': String OnSecondary,
        'surface': String Surface,
        'onSurface': String OnSurface,
        'error': String Error,
        'onError': String OnError,
        'Raum': String raumID
      } =>
          DBTheme(
            brigthness: Brigthness,
            background: Background,
            onBackground: OnBackground,
            primary: Primary,
            onPrimary: OnPrimary,
            secondary: Secondary,
            onSecondary: OnSecondary,
            surface: Surface,
            onSurface: OnSurface,
            error: Error,
            onError: OnError,
            RaumId: raumID),
      _ => throw const FormatException('Failed to load Theme.'),
    };
  }
  Map<String, dynamic> toJson() => {
        'brightness': brigthness,
        'background': background,
        'onBackground': onBackground,
        'primary': primary,
        'onPrimary': onPrimary,
        'secondary': secondary,
        'onSecondary': onSecondary,
        'surface': surface,
        'onSurface': onSurface,
        'error': error,
        'onError': onError,
        'Raum': RaumId
      };
}
ColorScheme ToThemeData(String jsonStr) {
  Map<String, dynamic> jsonData = json.decode(jsonStr);

  Brightness brightness;
  if (jsonData['brightness'] == 'light') {
    brightness = Brightness.light;
  } else {
    brightness = Brightness.dark;
  }

  return
    ColorScheme(
      brightness: brightness,
      background: Color(jsonData['background']),
      onBackground: Color(jsonData['onBackground']),
      primary: Color(jsonData['primary']),
      onPrimary: Color(jsonData['onPrimary']),
      secondary: Color(jsonData['secondary']),
      onSecondary: Color(jsonData['onSecondary']),
      surface: Color(jsonData['surface']),
      onSurface: Color(jsonData['onSurface']),
      error: Color(jsonData['error']),
      onError: Color(jsonData['onError']),
    );
}
