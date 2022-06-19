import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/shlok_feed_card.dart';

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
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index)  {
                  return ShlokFeedCard(
                    currentShlok: documents[index]['chapter_shlok'],
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}
