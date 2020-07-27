import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:polymathic/utils/constants.dart';
import 'main_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final String _introSvg = 'assets/svg/thinking.svg';
  bool _isNextEnabled = false;
  String name = 'undefined';

  void saveName(String name) async {
    print('Saved name to SharedPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setBool('firstLaunch', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Polymathic',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 64),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  _introSvg,
                  height: 256,
                  semanticsLabel: 'Introduction Image',
                ),
                SizedBox(
                  height: 64,
                ),
                Container(
                  width: 256,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        fillColor: kPrimaryColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(64.0),
                          ),
                          borderSide: BorderSide(
                            width: 0.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(64.0),
                          ),
                          borderSide: BorderSide(
                            width: 0.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(64.0),
                          ),
                          borderSide: BorderSide(
                            width: 0.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.white54),
                        hintText: 'What\'s your name?'),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      name = value;

                      setState(() {
                        if (value != null && value != '') {
                          print('enabled');
                          _isNextEnabled = true;
                        } else {
                          print('disabled');
                          _isNextEnabled = false;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isNextEnabled,
        child: FloatingActionButton(
          child: Icon(MaterialIcons.navigate_next),
          onPressed: () {
            saveName(name);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  title: 'Polymathic',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
