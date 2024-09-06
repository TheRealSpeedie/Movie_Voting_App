import 'package:flutter/material.dart';

const textColor = Color(0xFFf3f2f3);
const backgroundColor = Color(0xFF0e0c0e);
const primaryColor = Color(0xFFbcaebb);
const primaryFgColor = Color(0xFF0e0c0e);
const secondaryColor = Color(0xFF664d64);
const secondaryFgColor = Color(0xFFf3f2f3);
const accentColor = Color(0xFF9b6f98);
const accentFgColor = Color(0xFF0e0c0e);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  background: backgroundColor,
  onBackground: textColor,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
);