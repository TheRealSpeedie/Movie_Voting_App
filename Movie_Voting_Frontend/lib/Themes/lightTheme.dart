import 'package:flutter/material.dart';

const textColor = Color(0xFF0d0c0d);
const backgroundColor = Color(0xFFf3f1f3);
const primaryColor = Color(0xFF514350);
const primaryFgColor = Color(0xFFf3f1f3);
const secondaryColor = Color(0xFFb299b0);
const secondaryFgColor = Color(0xFF0d0c0d);
const accentColor = Color(0xFF90648d);
const accentFgColor = Color(0xFFf3f1f3);

const ligthColorScheme = ColorScheme(
  brightness: Brightness.light,
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
  error: Brightness.light == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
);


