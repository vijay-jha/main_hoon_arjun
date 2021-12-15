import 'package:flutter/material.dart';

import '../widgets/comment.dart';
import '../constants.dart';

class CommentScreen extends StatefulWidget {

  static const routeName = '/comment-screen';

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
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
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 45.0,
                  width: 45.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
              ),
              subtitle: Text(
                data[i]['message'],
                style: TextStyle(fontSize: 17, color: Colors.white70, fontWeight:FontWeight.w600 ,)
              ),
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
      body: Container(
        child: CommentBox(
          userImage: "https://picsum.photos/200/400",
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () {
            if (formKey.currentState.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': 'New User',
                  'pic': 'https://picsum.photos/200/400',
                  'message': commentController.text
                };
                filedata.insert(0, value);
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: backgroundC,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
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