import 'package:flutter/material.dart';

import '../widgets/shlok_post.dart';
import '../constants.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key key}) : super(key: key);

  static const routeName = '/feed-screen';
  final String sample = "Feed Screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
      appBar: AppBar(
        backgroundColor: backgroundC,
        elevation: 0,
        title: TextBox(),
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.search,
            color: primaryTextC,
          ),
        ),
      ),
      body: ListView.builder(itemCount: 10,itemBuilder: (BuildContext context, int index) {return ShlokPost();}),
    );
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: backgroundC,
      child: const TextField(
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }
}
