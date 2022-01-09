import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../navigationFile.dart';

class LoginSplash extends StatefulWidget {
  @override
  _LoginSplashState createState() => _LoginSplashState();
}

class _LoginSplashState extends State<LoginSplash>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed(NavigationFile.routeName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned(
          top: -50,
          left: -50,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFFFF521B),
            ),
          ),
        ),
        Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFFF521B),
              ),
            )),
        Positioned(
            bottom: -240,
            right: 0,
            child: Container(
              width: 400,
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: const Color(0xFFFF521B),
              ),
            )),
        Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.33),
              padding: const EdgeInsets.symmetric(horizontal: 80),
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Lottie.asset(
                'assets/lottie/EmailVerified.json',
                height: MediaQuery.of(context).size.height * 0.35,
                controller: _controller,
                animate: true,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                top: MediaQuery.of(context).size.height * 0.47,
              ),
              child: const Text(
                "You have successfully logged in !",
                style: TextStyle(
                    color: Color(0xFFFF521B),
                    fontSize: 29,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
