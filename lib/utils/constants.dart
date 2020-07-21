import 'package:flutter/material.dart';

const kPrimaryColor = Colors.indigo;
const kAccentColor = Colors.pink;
const kDisabledTextColor = Colors.grey;

final ThemeData kLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kPrimaryColor,
  accentColor: kAccentColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    elevation: 0,
    brightness: Brightness.dark,
    color: Colors.transparent,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        width: 3,
        color: Colors.black,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
  ),
);

final ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kPrimaryColor,
  accentColor: kAccentColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    elevation: 0,
    brightness: Brightness.dark,
    color: Colors.transparent,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        width: 3,
        color: Colors.white,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
  ),
);
