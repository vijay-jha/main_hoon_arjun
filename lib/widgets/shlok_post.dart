// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/comment_screen.dart';

class ShlokPost extends StatelessWidget {
  String sample = "User";
  String shlok =
      "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
          ),
        ),
        elevation: 5,
        child: Column(
          children: [
            //name settings
            Container(
              decoration: const BoxDecoration(
                color: primaryTextC,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      sample,
                      style: const TextStyle(
                        color: secondaryC,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.more_vert_sharp,
                      color: secondaryC,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryTextC,
                  border: Border.all(color: Colors.black12, width: 0.5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: shlok,
                    style: const TextStyle(
                      color: Colors.white,
                      // background: secondaryC,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryTextC,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const IconButton(
                    icon: Icon(
                      Icons.arrow_upward_sharp,
                      color: secondaryC,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CommentScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.comment,
                      color: secondaryC,
                    ),
                  ),
                  const IconButton(
                    icon: Icon(
                      Icons.share,
                      color: secondaryC,
                    ),
                  ),
                ],
              ),
            )
            //like comment share
          ],
        ),
      ),
    );
  }
}
