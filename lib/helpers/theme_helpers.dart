import 'package:flutter/material.dart';

abstract class ThemeHelpers {
  static const AccentColor = 0xFFFFB443;

  static const PrimaryColor = 0xFF38B6FF;

  static final buttonStyle = ButtonStyle(
    fixedSize: MaterialStateProperty.all(Size(300, 45)),
    backgroundColor: MaterialStateProperty.all(
      Color(PrimaryColor),
    ),
  );
}
