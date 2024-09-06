import 'dart:ui';

import 'package:flutter/material.dart';

class ColorpickerController{
  Color _color;

  ColorpickerController({Color? initialColor}) : _color = initialColor ?? Colors.transparent;

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }
}