// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/mahabharat_characters.dart';
import 'package:main_hoon_arjun/screens/homepage_screen.dart';
import 'package:main_hoon_arjun/widgets/profile_picture.dart';
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
  bool isLiked = false;

  void _postComment(comment) async {
    final _user = FirebaseAuth.instance.currentUser;
    var userInfo = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    var userData = userInfo.data();

    final data = await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .get();
    if (!data.exists) {
      await FirebaseFirestore.instance
          .collection('Feed')
          .doc(widget.currentShloK)
          .set({
        'count': 1,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Feed')
          .doc(widget.currentShloK)
          .update({
        'count': data['count'] + 1,
      });
    }

    await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .collection('comments')
        .doc('${widget.currentShloK}_${data['count']}')
        .set({
      'createdAt': Timestamp.now(),
      'commentID': "${widget.currentShloK}_${data['count']}",
      'user': _user.uid,
      'username': userData['username'],
      'avatarIndex': userData['avatarIndex'],
      'comment': comment,
    });
    //     .add({
    //   'createdAt': Timestamp.now(),
    //   'commentID': "${widget.currentShloK}_${data.docs.length}",
    //   'user': _user.uid,
    //   'username': userData['username'],
    //   'avatarIndex': userData['avatarIndex'],
    //   'comment': comment,
    // });
  }

  void handleLikes() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Widget commentChild(data) {
    return ListView.builder(
        itemBuilder: (context, index) => CommentStructure(
            isLiked: isLiked,
            handleLikes: handleLikes,
            username: data[index]['username'],
            avatarIndex: data[index]['avatarIndex'],
            comment: data[index]['comment']),
        itemCount: data.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Comments'),
        elevation: 0,
        backgroundColor: Colors.orange,
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
                  _postComment(commentController.text);
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
  final bool isLiked;
  final String username;
  final String comment;
  final int avatarIndex;
  final Function handleLikes;
  CommentStructure(
      {this.username,
      this.comment,
      this.avatarIndex,
      this.handleLikes,
      this.isLiked});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return ProfilePictureDialog(
                        avatarIndex: avatarIndex,
                        username: username,
                      );
                    });
              },
              child: CircleAvatar(
                backgroundColor: Colors.orange.shade50,
                radius: 30,
                child: Image.asset(
                  Provider.of<MahabharatCharacters>(context, listen: true)
                      .getChosenAvatarLink(),
                  fit: BoxFit.cover,
                ),
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
              //like button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: handleLikes,
                    child: Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                        child: Icon(
                          Icons.arrow_upward_outlined,
                          color: isLiked ? Colors.yellow : Colors.white,
                          size: 16,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                    child: Text(
                      "1",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
