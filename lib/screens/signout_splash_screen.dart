import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/mahabharat_characters.dart';

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
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Provider.of<MahabharatCharacters>(context, listen: false)
            .deleteIndexFromLocal();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
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
    Size _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Stack(children: [
        Positioned(
          top: -(_deviceSize.height * 0.058),
            left: -(_deviceSize.width * 0.127),
          child: Container(
            width: _deviceSize.width * 0.5,
            height: _deviceSize.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFFFF521B),
            ),
          ),
        ),
        Positioned(
            top: _deviceSize.height * 0.14,
            right: -(_deviceSize.width * 0.127),
            child: Container(
              width: _deviceSize.width * 0.28,
              height: _deviceSize.height * 0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFFFF521B),
              ),
            )),
        Positioned(
            bottom: -(_deviceSize.height * 0.35),
            child: Container(
              width: _deviceSize.width * 1,
              height: _deviceSize.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Color(0xFFFF521B),
              ),
            )),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.33),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.203,
              ),
              child: Lottie.asset(
                'assets/lottie/signout_namaste.json',
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
                left: _deviceSize.height * 0.1,
                right: _deviceSize.height * 0.1,
                top: _deviceSize.height * 0.42,
              ),
              child: const Text(
                "धन्यवाद!",
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
