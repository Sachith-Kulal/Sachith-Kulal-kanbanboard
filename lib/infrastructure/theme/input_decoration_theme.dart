import 'package:flutter/material.dart';

class InputDecorationThemes {
  static InputDecorationTheme light = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.50,
        color: Colors.black.withOpacity(0.5),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.50,
        color: Colors.black.withOpacity(0.5),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.50,
        color: Colors.black.withOpacity(0.5),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
  );

  static InputDecorationTheme dark =  InputDecorationTheme(
    filled: true,
    fillColor: Colors.black,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.50,
        color: Colors.white.withOpacity(0.25),
        // width: 23,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.50,
        color: Colors.black.withOpacity(0.25),
        // width: 23,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.50,
        color: Colors.black.withOpacity(0.25),
        // width: 23,
      ),
      // borderSide:  BorderSide(color: Colors.pinkAccent,width: 3),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
  );
}
