// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './desired_shlok_screen.dart';
import '../widgets/profile_picture.dart';
import '../providers/mahabharat_characters.dart';

class HomepageScreen extends StatefulWidget {
  static const routeName = '/homepage-screen';
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  FocusNode inputNode = FocusNode();
   
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  Provider.of<MahabharatCharacters>(context, listen: false)
    //       .getIndexFromLocal();
  }
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  // void onRetrive() async {
  //   final snap = await FirebaseFirestore.instance
  //       .collection("Geeta")
  //       .snapshots()
  //       .listen((event) {
  //     (event.docs.forEach((element) {
  //       print("iiiiiiiiiiiii");
  //       var e = element.data();
  //       print(e['Shlok01']['translation']['hindi']);
  //     }));
  //   });
  // }

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