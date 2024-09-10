import 'package:flutter/material.dart';

class FloatingActionButtonTheme {
  static FloatingActionButtonThemeData light = ThemeData.light().floatingActionButtonTheme.copyWith(
    backgroundColor: const Color(0xff37b8ff),
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );

  static FloatingActionButtonThemeData dark =  ThemeData.dark().floatingActionButtonTheme.copyWith(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
