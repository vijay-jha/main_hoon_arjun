// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/mahabharat_characters.dart';
import 'package:provider/provider.dart';

import '../widgets/comment.dart';
import '../constants.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment-screen';
  final currentShloK;

  // ignore: use_key_in_widget_constructors
  const CommentScreen({this.currentShloK});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var comments;

  void _postComment(comment) async {
    final _user = FirebaseAuth.instance.currentUser;
    var userInfo = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    var userData = userInfo.data();

    await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .collection('comments')
        .add({
      'createdAt': Timestamp.now(),
      'user': _user.uid,
      'username': userData['username'],
      'avatarIndex': userData['avatarIndex'],
      'comment': comment,
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          CommentStructure(
              username: data[i]['username'],
              avatarIndex: data[i]['avatarIndex'],
              comment: data[i]['comment'])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Comments'),
        elevation: 0,
        backgroundColor: backgroundC,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Feed')
            .doc(widget.currentShloK)
            .collection('comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CommentBox(
              userImage: "",
              child: commentChild(snapshot.data.docs),
              labelText: 'Write a comment...',
              errorText: 'Comment cannot be blank',
              withBorder: false,
              sendButtonMethod: () {
                if (formKey.currentState.validate()) {
                  _postComment(commentController.text.trim());
                  commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
              formKey: formKey,
              commentController: commentController,
              backgroundColor: backgroundC,
              textColor: Colors.white,
              sendWidget: Icon(
                Icons.send_sharp,
                size: 30,
                color: Colors.white,
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class CommentStructure extends StatelessWidget {
  final String username;
  final String comment;
  final int avatarIndex;
  CommentStructure({this.username, this.comment, this.avatarIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: CircleAvatar(
              backgroundColor: Colors.orange.shade50,
              radius: 30,
              child: Image.asset(
                Provider.of<MahabharatCharacters>(context, listen: true)
                    .getCharacterImageLink(avatarIndex),
                fit: BoxFit.cover,
              ),
            ),
            height: 30.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 280,
                padding: EdgeInsets.all(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Container(
                width: 280,
                child: Text(
                  comment,
                  style: TextStyle(color: Colors.white),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
