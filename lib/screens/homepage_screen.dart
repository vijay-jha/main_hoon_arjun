// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'dart:convert';

import './desired_shlok_screen.dart';
import '../widgets/profile_picture.dart';
import '../api.dart' as api;
import '../constants.dart' show FEELING_API;

class HomepageScreen extends StatefulWidget {
  static const routeName = '/homepage-screen';
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;

  setLoading(bool isLoad) {
    setState(() {
      isLoading = isLoad;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Main Hoon Arjun"),
          actions: [ProfilePicture()],
        ),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.only(top: 15),
                  margin: EdgeInsets.symmetric(
                    vertical: _deviceSize.height * 0.05,
                    horizontal: _deviceSize.width * 0.05,
                  ),
                  // padding: EdgeInsets.only(top: ),
                  child: SearchBar(setLoading),
                ),
                if (!isLoading)
                  Container(
                    margin: EdgeInsets.only(top: _deviceSize.height * 0.08),
                    child: HandWave(),
                  ),
                if (isLoading)
                  SizedBox(
                    height: _deviceSize.height * 0.2,
                  ),
                if (isLoading)
                  SpinKitFadingCircle(
                    color: Colors.orange,
                  ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar(this.isLoading);
  final Function isLoading;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode inputNode = FocusNode();

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return TextField(
        onSubmitted: (feeling) async {
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 500), () {});
          // setState(() {
          widget.isLoading(true);
          // });
          if (feeling.isNotEmpty) {
            var url = Uri.parse('$FEELING_API/feeling?query=' + feeling.trim());
            var data = await api.getData(url);
            var decodedData = json.decode(data);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DesiredShlokScreen(emotions: decodedData),
              ),
            );
            widget.isLoading(false);
          } else {
            widget.isLoading(false);
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.orange.shade50,
                content: Text("Please enter something about your feeling."),
                actions: [
                  OutlinedButton(
                      onPressed: () async {
                        await Future.delayed(Duration(milliseconds: 200));
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay")),
                ],
              ),
            );
          }
        },
        focusNode: inputNode,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: " Search  ( e.g. I am Happy )",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 18,
          ),
        ),
        // autofocus: true,
        style: TextStyle(fontSize: 20, color: Colors.orange.shade400),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sorry, Failed to load. Please Try Again 🙏',
            style: TextStyle(color: Colors.orange),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }
}

class HandWave extends StatefulWidget {
  HandWave();
  @override
  _HandWaveState createState() => _HandWaveState();
}

class _HandWaveState extends State<HandWave> with TickerProviderStateMixin {
  var isreverse = false;
  AnimationController _controller;
  var username;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isreverse) {
          isreverse = true;
          _controller.repeat(
              min: _controller.lowerBound,
              max: _controller.upperBound,
              reverse: true);
        } else {
          isreverse = false;
          _controller.repeat(
              min: _controller.lowerBound, max: _controller.upperBound);
        }
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
    return KeyboardVisibilityBuilder(builder: (context, visible) {
      return !visible
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Lottie.asset(
                    'assets/lottie/HandWave.json',
                    height: MediaQuery.of(context).size.height * 0.30,
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
                  child: username == null
                      ? FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .get(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              username = snapshot.data['username'];
                            }
                            return Text(
                              snapshot.hasData
                                  ? """
    Hi ${snapshot.data['username']}
    How are you feeling now ?
    """
                                      .trim()
                                  : """
    Hi 
    How are you feeling now ?
    """
                                      .trim(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.orange.shade400,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                            );
                          },
                        )
                      : Text(
                          """
    Hi ${username}
    How are you feeling now ?
        """,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.orange.shade400,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025),
                        ),
                )
              ],
            )
          : Center();
    });
  }
}
