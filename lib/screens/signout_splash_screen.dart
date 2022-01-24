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
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.33),
              padding: const EdgeInsets.symmetric(horizontal: 80),
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
                left: 24,
                right: 24,
                top: MediaQuery.of(context).size.height * 0.47,
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
