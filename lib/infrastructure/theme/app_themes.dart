import 'package:flutter/material.dart';
import 'app_floatinga_action_button_theme.dart';
import 'input_decoration_theme.dart';

class AppThemes {
  static ThemeData light(context) => ThemeData.light()
      .copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        inputDecorationTheme: InputDecorationThemes.light,
        textTheme: ThemeData.light().textTheme,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: Colors.grey[300],
            ),
        bottomNavigationBarTheme: ThemeData.light()
            .bottomNavigationBarTheme
            .copyWith(
                selectedItemColor: Colors.blue,
                unselectedItemColor: const Color(0xFF777575)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff37b8ff),
          foregroundColor: Colors.white,
          shadowColor: const Color(0xff37b8ff),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        )),
        floatingActionButtonTheme: FloatingActionButtonTheme.light,
      )
      .copyWith(
        primaryColorLight: Colors.black.withOpacity(0.5),
      );

  static ThemeData dark(context) => ThemeData.dark()
      .copyWith(
          textTheme: ThemeData.dark().textTheme,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shadowColor: const Color(0xff37b8ff),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          )),
          inputDecorationTheme: InputDecorationThemes.dark,
          bottomNavigationBarTheme: ThemeData.dark()
              .bottomNavigationBarTheme
              .copyWith(
                  selectedItemColor: Colors.white,
                  unselectedItemColor: const Color(0xFF777575)),
          floatingActionButtonTheme: FloatingActionButtonTheme.dark)
      .copyWith(
        primaryColorLight: Colors.white,
      );
}
