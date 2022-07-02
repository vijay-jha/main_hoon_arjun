// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:main_hoon_arjun/providers/mahabharat_characters.dart';
import 'package:main_hoon_arjun/widgets/no_item_in_list.dart';
import 'package:main_hoon_arjun/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

import '../widgets/comment_box.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment-screen';
  final currentShloK;
  final Size size;

  // ignore: use_key_in_widget_constructors
  const CommentScreen({this.currentShloK, this.size});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool isLiked = false;
  List<dynamic> allUsers = [];
  var data;

  @override
  void dispose() {
    commentController.clear();
    super.dispose();
  }

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
          'chapter_shlok': widget.currentShloK,
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
      'likesCount': 0,
      'likes': [],
      'comment': comment,
    });

    await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.currentShloK)
        .set({
      'count': data['count'] + 1,
      "chapter_shlok": widget.currentShloK,
    });
  }

  Widget commentChild(data) {
    if (data.length == 0) {
      return KeyboardVisibilityBuilder(builder: (context, visible) {
        return !visible
            ? FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 500)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: widget.size.height * 0.12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmptyList(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              " Add your thoughts !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.orange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center();
                })
            : Center();
      });
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var commenter = allUsers.indexWhere(
              (element) => element['email'] == data[index]['useremail']);
          return CommentStructure(
              size: widget.size,
              likesData: data[index]['likes'],
              email: data[index]['useremail'],
              commentId: data[index]['commentId'],
              isLiked: isLiked,
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
                  .orderBy("likesCount", descending: true)
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
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    sendWidget: Icon(
                      Icons.send_sharp,
                      size: widget.size.height * 0.035,
                      color: Colors.white,
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

class CommentStructure extends StatefulWidget {
  final String commentId;
  bool isLiked;
  final String username;
  final String comment;
  final int avatarIndex;
  final String email;
  final likesData;
  final size;

  CommentStructure({
    this.size,
    this.username,
    this.email,
    this.likesData,
    this.commentId,
    this.comment,
    this.avatarIndex,
    this.isLiked,
  });

  @override
  State<CommentStructure> createState() => _CommentStructureState();
}

class _CommentStructureState extends State<CommentStructure> {
  void handleLikes(commentId, userId) async {
    var data = await FirebaseFirestore.instance
        .collection('Feed')
        .doc(widget.commentId.replaceRange(17, widget.commentId.length, ""))
        .collection('comments')
        .doc(commentId)
        .get();
    var likesCount = data.data()['likesCount'];
    var likes = data.data()['likes'];
    if (!likes.contains(userId)) {
      FirebaseFirestore.instance
          .collection('Feed')
          .doc(widget.commentId.replaceRange(17, widget.commentId.length, ""))
          .collection('comments')
          .doc(commentId)
          .set({
        'likes': FieldValue.arrayUnion([userId]),
        'likesCount': likesCount + 1
      }, SetOptions(merge: true));
    } else {
      FirebaseFirestore.instance
          .collection('Feed')
          .doc(widget.commentId.replaceRange(17, widget.commentId.length, ""))
          .collection('comments')
          .doc(commentId)
          .set({
        'likes': FieldValue.arrayRemove([userId]),
        'likesCount': likesCount - 1
      }, SetOptions(merge: true));
    }
  }

  var _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    widget.isLiked = widget.likesData.contains(_user.uid);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.orange.shade400,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 7.0,
          ),
        ],
        color: Colors.orange.shade100,
      ),
      padding: EdgeInsets.only(
        bottom: widget.size.height * 0.02,
        top: widget.size.height * 0.02,
      ),
      margin: EdgeInsets.only(bottom: widget.size.height * 0.02),
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
                        avatarIndex: widget.avatarIndex,
                        username: widget.username,
                      );
                    });
              },
              child: CircleAvatar(
                backgroundColor: Colors.orange.shade50,
                radius: 30,
                child: Image.asset(
                  Provider.of<MahabharatCharacters>(context, listen: true)
                      .getCharacterImageLink(widget.avatarIndex),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            height: widget.size.height * 0.05,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                width: widget.size.width * 0.8,
                padding: EdgeInsets.all(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      height: widget.size.height * 0.035,
                      child: PopupMenuButton(
                          color: Colors.orange.shade400,
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.orange,
                            size: widget.size.height * 0.025,
                          ),
                          itemBuilder: (context) => [
                                _user.email == widget.email
                                    ? PopupMenuItem(
                                        height: widget.size.height * 0.03,
                                        value: 'delete',
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : PopupMenuItem(
                                        height: widget.size.height * 0.03,
                                        value: 'report',
                                        child: Text(
                                          'Report',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                              ],
                          onSelected: (item) async {
                            if (item == 'delete') {
                              if (_user.email == widget.email) {
                                final snackbar = SnackBar(
                                  margin: EdgeInsets.fromLTRB(
                                      0, 0, 0, widget.size.height * 0.02),
                                  content: Text(
                                    "Deleted Successfully",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  backgroundColor: Colors.orange[100],
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                );
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.orange.shade50,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                .doc(widget.commentId
                                                    .replaceRange(
                                                        17,
                                                        widget.commentId.length,
                                                        ""))
                                                .collection('comments')
                                                .doc(widget.commentId)
                                                .delete();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbar);
                                          },
                                          child: Text("Delete")),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              final snackbar = SnackBar(
                                margin: EdgeInsets.fromLTRB(
                                    0, 0, 0, widget.size.height * 0.02),
                                content: Text(
                                  "Reported Successfully",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                backgroundColor: Colors.orange[100],
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              );
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        backgroundColor: Colors.orange.shade50,
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text("Report Comment"),
                                            Divider(
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                            "Do you really want to report this comment?"),
                                        actions: [
                                          OutlinedButton(
                                              onPressed: () async {
                                                await Future.delayed(Duration(
                                                    milliseconds: 200));
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel")),
                                          OutlinedButton(
                                              onPressed: () async {
                                                await Future.delayed(Duration(
                                                    milliseconds: 200));
                                                // Deleting Comment
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'reported_comments')
                                                    .doc(widget.commentId
                                                        .replaceRange(
                                                            17,
                                                            widget.commentId
                                                                .length,
                                                            ""))
                                                    .set({
                                                  'comment-id':
                                                      FieldValue.arrayUnion(
                                                          [widget.commentId])
                                                }, SetOptions(merge: true));
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(snackbar);
                                              },
                                              child: Text("Report")),
                                        ],
                                      ));
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                width: widget.size.width * 0.8,
                child: Text(
                  widget.comment,
                  style: TextStyle(color: Colors.orange, fontSize: 15),
                  softWrap: true,
                ),
              ),
              //like button
              InkWell(
                onTap: () {
                  setState(() {
                    widget.isLiked = !widget.isLiked;
                  });
                  handleLikes(widget.commentId, _user.uid);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.only(
                          top: widget.size.height * 0.01,
                          right: widget.size.width * 0.05,
                        ),
                        child: Icon(
                          widget.isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_alt_outlined,
                          // color: widget.isLiked ? Colors.yellow : Colors.orange,
                          color: Colors.orange,
                          size: widget.size.height * 0.02,
                        )),
                    Container(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(
                        top: widget.size.height * 0.01,
                      ),
                      child: Text(
                        widget.likesData.length.compareTo(0) == 0
                            ? " "
                            : widget.likesData.length.toString(),
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
