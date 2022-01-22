import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/screens/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './auth_screen.dart';
import './introduction_screen.dart';

class OneTimeIntro extends StatefulWidget {
  @override
  _OneTimeIntroState createState() => _OneTimeIntroState();
}

class _OneTimeIntroState extends State<OneTimeIntro> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacementNamed(IntroductionScreens.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
