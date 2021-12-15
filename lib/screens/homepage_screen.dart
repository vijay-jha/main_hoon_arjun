// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/screens/feed_screen.dart';

import './geeta_read_screen.dart';
import './desired_shlok_screen.dart';
import './favorites_screen.dart';
import '../widgets/profile_picture.dart';

class HomepageScreen extends StatefulWidget {
  static const routeName = '/homepage-screen';
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Hoon Arjun"),
        actions: [ProfilePicture()],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: TextField(
          onSubmitted: (feeling) {
            if (feeling.isNotEmpty) {
              Navigator.pushNamed(context, DesiredShlokScreen.routeName);
            }
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: "How you are feeling today?",
            hintStyle: TextStyle(color: Colors.blue),
          ),
          // autofocus: true,
          style: TextStyle(fontSize: 20, color: Colors.teal),
        ),
      ),
      backgroundColor: Colors.orange.shade300,
    );
  }
}

// Todo 
// 1) Add bottombarNavigation
// 2) Save the text/feeling
// 3) And clear the input field after onSubmitted