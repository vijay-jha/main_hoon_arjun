// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/widgets/profile_picture.dart';

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

  // var snapshot;
  // void _getComments() async {
  //   snapshot = (await FirebaseFirestore.instance
  //       .collection('Feed')
  //       .doc(widget.currentShloK)
  //       .collection('comments')
  //       .get());
  // }

  @override
  void initState() {
    // _getComments();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Vijay Jha',
      'pic': 'https://picsum.photos/200/300',
      'message': "Great Shlok"
    },
    {
      'name': 'Akshay Gade',
      'pic': 'https://picsum.photos/200/200',
      'message': "Best Shlok"
    },
    {
      'name': 'Vinay Bhujbal',
      'pic': 'https://picsum.photos/200/100',
      'message': "Excellent Shlok"
    },
    {
      'name': 'Pranavraj Goje',
      'pic': 'https://picsum.photos/100/300',
      'message': 'Noice Shlok'
    },
  ];

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                },
                child: ProfilePicture(),
                // child: Container(
                //   height: 45.0,
                //   width: 45.0,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(50))),
                //   child: ProfilePicture(),
                // ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white),
              ),
              subtitle: Text(data[i]['message'],
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
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
              var data = snapshot.data.docs;
              printData(data);
            }
            return CommentBox(
              userImage: "",
              child: commentChild(filedata),
              labelText: 'Write a comment...',
              errorText: 'Comment cannot be blank',
              withBorder: false,
              sendButtonMethod: () {
                if (formKey.currentState.validate()) {
                  setState(() {
                    var value = {
                      'name': 'New User',
                      'pic': 'https://picsum.photos/200/400',
                      'message': commentController.text
                    };
                    filedata.insert(0, value);
                  });
                  _postComment(commentController.text);
                  commentController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
              formKey: formKey,
              commentController: commentController,
              backgroundColor: backgroundC,
              textColor: Colors.white,
              sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
            );
          }),
    );
  }

  void printData(var data) {
    // print(data[0]['comment']);
  }
}

// class AddCommentBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       color: backgroundC,
//       child: const TextField(
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: 'Comment',
//         ),
//       ),
//     );
//     // GestureDetector(
//     //   child: const Icon(Icons.send),
//     //   onTap: () {},
//     // )
//   }
// }