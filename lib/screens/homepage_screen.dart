// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './desired_shlok_screen.dart';
import '../widgets/profile_picture.dart';
import '../widgets/geeta.dart';

class HomepageScreen extends StatefulWidget {
  static const routeName = '/homepage-screen';
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  FocusNode inputNode = FocusNode();

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  void _onDoubleTapShlok() async {
    for (int i = 0; i < geeta.length; i++) {
      await FirebaseFirestore.instance
          .collection('Geeta')
          .doc('Chapter${geeta[i]["chapter"]}')
          .update({
        'Shlok${geeta[i]["shlok"]}': {
          'chapter': geeta[i]["chapter"],
          'shlok': geeta[i]["shlok"],
          'text': geeta[i]["text"],
          'translation': {
            'english': geeta[i]["translation-eng"],
            'hindi': geeta[i]["translation-hin"],
          },
          'meaning': {
            'english': geeta[i]["meaning-eng"],
            'hindi': geeta[i]["meaning-hin"],
          }
        }
      });
      print("iiiiiiiiiiiiiiii = " + i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Hoon Arjun"),
        actions: [ProfilePicture()],
      ),
      body: Column(children: [
        Container(
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
            focusNode: inputNode,
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
        InkWell(
          onDoubleTap: _onDoubleTapShlok,
          child: Container(
            alignment: Alignment.center,
            width: 120,
            height: 35,
            child: Text(
              "Upload Geeta",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red[800],
          ),
        )
      ]),
      backgroundColor: Colors.transparent,
    );
  }
}

// Todo 
// 1) Add bottombarNavigation
// 2) Save the text/feeling
// 3) And clear the input field after onSubmitted