import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import './auth_screen.dart';

class SignOutSplashScreen extends StatefulWidget {
  @override
  _SignOutSplashScreenState createState() => _SignOutSplashScreenState();

  static const routeName = '/sign-out-splash-screen';
}

class _SignOutSplashScreenState extends State<SignOutSplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        children: [
          Center(
            child: Lottie.asset(
              'assets/lottie/green_bye.json', //change the path here
              controller: _controller,
              height: MediaQuery.of(context).size.height * 1,
              animate: true,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward().whenComplete(
                    () => Navigator.of(context).pushNamedAndRemoveUntil(
                        AuthScreen.routeName, (route) => false),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
