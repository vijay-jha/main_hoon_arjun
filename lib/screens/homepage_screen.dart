// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/profile_picture.dart';
import '../screens/desired_shlok_screen.dart';
import '../screens/choose_avatar_screen.dart';

class HomepageScreen extends StatefulWidget {
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>  with TickerProviderStateMixin  {
  var _currentPageIndex = 1;

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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) async {
          setState(() {
            _currentPageIndex = index;
          });
          if (_currentPageIndex == 2) {
            Navigator.pushNamed(context, ChooseAvatarScreen.routeName);
          }
        },
        currentIndex: _currentPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comment"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome), label: "Shlok"),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share App"),
        ],
      ),
      backgroundColor: Colors.orange.shade300,
    );
  }
}

// Todo 
// 1) Add bottombarNavigation
// 2) Save the text/feeling
// 3) And clear the input field after onSubmitted