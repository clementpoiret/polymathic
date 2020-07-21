import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/intro_screen.dart';
import 'screens/main_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(Polymathic());
}

class Polymathic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polymathic',
      theme: ThemeData(
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
      ),
      darkTheme: ThemeData(
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
      ),
      home: FirstLaunch(),
    );
  }
}

class FirstLaunch extends StatefulWidget {
  @override
  _FirstLaunchState createState() => _FirstLaunchState();
}

class _FirstLaunchState extends State<FirstLaunch> {
  Future checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _firstLaunch = (prefs.getBool('firstLaunch') ?? true);

    print('_firstLaunch: $_firstLaunch');

    if (!_firstLaunch) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(
            title: 'Polymathic',
          ),
        ),
      );
    } else {
      // await prefs.setBool('firstLaunch', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
