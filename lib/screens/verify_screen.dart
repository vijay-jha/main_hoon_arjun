// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_hoon_arjun/navigationFile.dart';

import './homepage_screen.dart';
import './auth_screen.dart';

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
  Timer timer;
  final _auth = FirebaseAuth.instance;
  User user;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
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
        await user.delete();
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You didn't verify the email on time. Try again."),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/loading.json', //change the path here
            controller: _controller,
            height: MediaQuery.of(context).size.height * 1,
            animate: true,
            repeat: true,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ],
      ),
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
      timer.cancel();
      Navigator.of(context).pushReplacementNamed(NavigationFile.routeName);
    }
  }
}
