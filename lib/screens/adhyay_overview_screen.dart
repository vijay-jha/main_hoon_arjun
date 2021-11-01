// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/profile_picture.dart';

class AdhyayOverviewScreen extends StatelessWidget {
  final String title;
  final String adhyayName;

  AdhyayOverviewScreen({this.title, this.adhyayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(adhyayName),
        actions: [ProfilePicture()],
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            color: Colors.pink,
            child: const Center(
              child: Text('page 1'),
            ),
          ),
          Container(
            color: Colors.blue,
            child: const Center(
              child: Text('page 2'),
            ),
          ),
          Container(
            color: Colors.orange,
            child: const Center(
              child: Text('page 3'),
            ),
          ),
        ],
      ),
    );
  }
}
