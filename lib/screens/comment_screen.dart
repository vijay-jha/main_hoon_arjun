// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/mahabharat_characters.dart';
// import 'package:main_hoon_arjun/screens/homepage_screen.dart';
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
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;
  var comments;
  bool isLiked = false;
  List<dynamic> allUsers = [];
  var likesData;
  var data;
  Map likes;

  @override
  void initState() {
    () async {
      data = await FirebaseFirestore.instance
          .collection('Feed')
          .doc(widget.currentShloK)
          .get();

      if (!data.exists) {
        await FirebaseFirestore.instance
            .collection('Feed')
            .doc(widget.currentShloK)
            .set({
          'count': 0,
        });
      }
    }();
    super.initState();
  }

  void _postComment(comment) async {
    final _user = FirebaseAuth.instance.currentUser;
    data = await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .get();

    await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .collection('comments')
        .doc('${widget.currentShloK}_${data['count'] + 1}')
        .set({
      'commentId': '${widget.currentShloK}_${data['count'] + 1}',
      'createdAt': Timestamp.now(),
      'useremail': _user.email,
      'comment': comment,
    });

    await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .set({'count': data['count'] + 1});
  }

  void handleLikes(commentId) async {
    setState(() {
      isLiked = !isLiked;
    });
    // isLiked = !isLiked;
  }

  Widget commentChild(data) {
    return ListView.builder(
        itemBuilder: (context, index) {
          var commenter = allUsers.indexWhere(
              (element) => element['email'] == data[index]['useremail']);
          return CommentStructure(
              currentShlok: widget.currentShloK,
              email: data[index]['useremail'],
              commentId: data[index]['commentId'],
              isLiked: isLiked,
              handleLikes: handleLikes,
              username: allUsers[commenter]['username'],
              comment: data[index]['comment'],
              avatarIndex: allUsers[commenter]['avatarIndex']);
        },
        itemCount: data.length);
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Comments'),
        elevation: 0,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            allUsers = snapshot.data.docs.map((e) => e.data()).toList();
            return StreamBuilder(
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
            );
          }
          return Container();
        },
      ),
    );
  }
}

class CommentStructure extends StatelessWidget {
  final String commentId;
  final bool isLiked;
  final String username;
  final String comment;
  final int avatarIndex;
  final Function handleLikes;
  final email;
  final String currentShlok;
  final _user = FirebaseAuth.instance.currentUser;

  CommentStructure({
    this.currentShlok,
    this.email,
    this.username,
    this.commentId,
    this.comment,
    this.avatarIndex,
    this.handleLikes,
    this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    print(commentId);
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.only(bottom: 15, top: 15),
      margin: EdgeInsets.only(top: 15, bottom: 15),
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
                      .getCharacterImageLink(avatarIndex),
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
                    PopupMenuButton(
                      color: Colors.black12,
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                      itemBuilder: (context) => [
                        _user.email == email
                            ? PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : PopupMenuItem(
                                value: 'report',
                                child: Text(
                                  'Report',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                      ],
                      onSelected: (item) async {
                        if (item == 'delete') {
                          if (_user.email == email) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.orange.shade50,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("Delete Comment"),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                                content: Text(
                                    "Do you really want to delete your comment?"),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () async {
                                        await Future.delayed(
                                            Duration(milliseconds: 200));
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel")),
                                  OutlinedButton(
                                      onPressed: () async {
                                        await Future.delayed(
                                            Duration(milliseconds: 200));
                                        // Deleting Comment
                                        FirebaseFirestore.instance
                                            .collection('Feed')
                                            .doc(currentShlok)
                                            .collection('comments')
                                            .doc(commentId)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Delete")),
                                ],
                              ),
                            );
                          }
                        } else {
                          await FirebaseFirestore.instance
                              .collection('reported_comments')
                              .doc(currentShlok)
                              .set({
                            'comment-id': FieldValue.arrayUnion([commentId])
                          }, SetOptions(merge: true));
                        }
                      },
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
                    onTap: () => handleLikes(commentId),
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
