import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/shlok_feed_card.dart';
import '../constants.dart';

class FeedScreen extends StatelessWidget {
  static const routeName = '/feed-screen';
  final String sample = "Feed Screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 10,
        title: Text("Your Thoughts on Shloks"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Feed").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // QuerySnapshot<Object> data =
              //     snapshot.data as QuerySnapshot<Object>;
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              for (int i = 0; i < documents.length; i++) {
                var data = documents[i]['chapter_shlok'];
                print(data);
              }
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return ShlokFeedCard();
                },
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
