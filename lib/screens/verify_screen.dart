// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_hoon_arjun/navigationFile.dart';

import 'auth_screen.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();

  final String email;
  final String password;
  VerifyScreen({
    this.email,
    this.password,
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
      if(status == AnimationStatus.completed){
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
                color: Color(0xFFFF521B),
              ),
            )),
        Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFFFF521B),
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
              padding:
                  !isVerified ? null : EdgeInsets.symmetric(horizontal: 80),
              child: !isVerified
                  ? Lottie.asset(
                      'assets/lottie/loading.json', //change the path here
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
                  left: 24,
                  right: 24,
                  top: MediaQuery.of(context).size.height * 0.47,
                  ),
              child: Text(
                !isVerified
                    ? 'We have sent you a email. Please verify it'
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
        'password': widget.password,
      });
     setState(() {
      isVerified = true;
    });
    timer.cancel();
  }
  }
}