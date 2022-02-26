// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import './auth_screen.dart';
import '../navigation_file.dart';
import '../providers/mahabharat_characters.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();

  final String email;

  VerifyScreen({
    this.email,
  });

  static const routeName = '/verify-screen';
}

class _VerifyScreenState extends State<VerifyScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _controllerEmailVerified;
  Timer timer;
  bool isVerified = false;
  final _auth = FirebaseAuth.instance;
  User user;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    _controllerEmailVerified = AnimationController(
      vsync: this,
    );

    _controllerEmailVerified.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed(NavigationFile.routeName);
      }
    });
    user = _auth.currentUser;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerification();
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        count++;
        if (count < 38) {
          _controller.reset();
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _deviceSize = MediaQuery.of(context).size;

    Timer(Duration(minutes: 1), () async {
      await user.reload();
      if (!user.emailVerified) {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You didn't verify the email. Try again."),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });

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
                color: Color(0xFFFF521B),
              ),
            )),
        Positioned(
            top: _deviceSize.height * 0.14,
            right: -(_deviceSize.width * 0.127),
            child: Container(
              width: _deviceSize.width * 0.28,
              height: _deviceSize.height * 0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFFFF521B),
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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.33),
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              padding: !isVerified
                  ? null
                  : EdgeInsets.symmetric(horizontal: _deviceSize.width * 0.203),
              child: !isVerified
                  ? Lottie.asset(
                      'assets/lottie/verify_loading.json', //change the path here
                      controller: _controller,
                      height: MediaQuery.of(context).size.height * 0.33,
                      animate: true,
                      repeat: true,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    )
                  : Lottie.asset(
                      'assets/lottie/EmailVerified.json',
                      height: MediaQuery.of(context).size.height * 0.35,
                      controller: _controllerEmailVerified,
                      animate: true,
                      onLoaded: (composition) {
                        _controllerEmailVerified
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
              child: Text(
                !isVerified
                    ? 'We have sent you an email. Please verify it'
                    : "Verified Successfully !",
                style: TextStyle(
                    color: Color(0xFFFF521B),
                    fontSize: 29,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Future<void> checkEmailVerification() async {
    user = _auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': widget.email,
        'username': 'Arjun',
        'avatarIndex': 0,
      });
      Provider.of<MahabharatCharacters>(context, listen: false)
          .saveAvatarTolocal();

      setState(() {
        isVerified = true;
      });
      timer.cancel();
    }
  }
}
