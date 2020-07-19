import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';

void main() {
  runApp(Polymathic());
}

class Polymathic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polymathic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Hi, what\'s your name?'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MaterialIcons.navigate_next),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainScreen(
                title: 'Polymathic',
              ),
            ),
          );
        },
      ),
    );
  }
}
