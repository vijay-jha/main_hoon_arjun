// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import './desired_shlok_screen.dart';
import '../widgets/profile_picture.dart';

class HomepageScreen extends StatefulWidget {
  static const routeName = '/homepage-screen';
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Hoon Arjun"),
        actions: [ProfilePicture()],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
            child: TextField(
              controller: _controller,
              // onSubmitted: (feeling) {
              //   FocusScope.of(context).unfocus();
              //   if (feeling.isNotEmpty) {
              //     Navigator.pushNamed(context, DesiredShlokScreen.routeName);
              //   }
              // },
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
          ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, DesiredShlokScreen.routeName);
                }
              },
              child: Text("go"))
        ],
      ),
      backgroundColor: Colors.orange.shade300,
    );
  }
}


// column add kiya
// go button dala
