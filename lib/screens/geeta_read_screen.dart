import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:main_hoon_arjun/screens/bookmark_screen.dart';

import '../adhyay_detail.dart';
import '../widgets/profile_picture.dart';
import '../widgets/adhyay.dart';

class GeetaReadScreen extends StatefulWidget {
  static const routeName = '/geeta-read-screen';

  @override
  State<GeetaReadScreen> createState() => _GeetaReadScreenState();
}

class _GeetaReadScreenState extends State<GeetaReadScreen> {
  var finalData = <Map<String, dynamic>>[];

  void initState() {
    super.initState();
    () async {
      var _user = FirebaseAuth.instance.currentUser;
      var doc = await FirebaseFirestore.instance
          .collection('Bookmark')
          .doc(_user.uid)
          .get();

      if (!doc.exists) {
        FirebaseFirestore.instance
            .collection('Bookmark')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({'bookmarked_shloks': []});
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ElevatedButton(
      //   child: const Icon(Icons.bookmark, color: Colors.orange,),
      //   style: ButtonStyle(
      //       shape: MaterialStateProperty.all<CircleBorder>(
      //         const CircleBorder(),
      //       ),
      //       backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade100)),
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => BookmarkScreen()));
      //   },
      // ),
      appBar: AppBar(
        title: const Text("Shrimad Bhagavad Geeta"),
        actions: [ProfilePicture()],
      ),
      backgroundColor: Colors.orange.shade50,
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingCircle(
              color: Colors.orange,
            );
          }
          return GridView.builder(
            clipBehavior: Clip.none,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 3,
              maxCrossAxisExtent: 320,
              mainAxisExtent: 275,
              crossAxisSpacing: 0.001,
            ),
            itemCount: geetaChapters.length,
            itemBuilder: (_, index) => Adhyay(
              geetaChapters[index]['number'],
              geetaChapters[index]['name'],
            ),
          );
        },
      ),
    );
  }
}
