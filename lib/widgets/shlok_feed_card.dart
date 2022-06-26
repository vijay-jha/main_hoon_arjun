// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/widgets/shareImage.dart';
import 'package:screenshot/screenshot.dart';

import '../constants.dart';
import '../screens/comment_screen.dart';

class ShlokFeedCard extends StatefulWidget {
  final currentShlok;
  final data;

  ShlokFeedCard({this.currentShlok, this.data});

  @override
  State<ShlokFeedCard> createState() => _ShlokFeedCardState();
}

class _ShlokFeedCardState extends State<ShlokFeedCard> {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final chapterAndShlok = widget.currentShlok.split('_');
    final _controller = ScreenshotController();
    return Screenshot(
      controller: _controller,
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Geeta')
              .doc(chapterAndShlok[0])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              var particularShlok = data[chapterAndShlok[1]];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _deviceSize.width * 0.03,
                  vertical: _deviceSize.height * 0.015,
                ),
                child: Card(
                  color: Colors.orange.shade100,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      //name settings
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _deviceSize.width * 0.03,
                                  vertical: _deviceSize.height * 0.02),
                              child: Text(
                                "अ.${chapterAndShlok[0].substring(7)}, श्लोक.${chapterAndShlok[1].substring(5)}",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                currentShloK: widget.currentShlok,
                                size: _deviceSize,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _deviceSize.width * 0.03),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: particularShlok['text'].trim(),
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: _deviceSize.width * 0.03,
                          vertical: _deviceSize.height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                      currentShloK: widget.currentShlok,
                                      size: _deviceSize,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.comment,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final image = await _controller.capture();
                                if (image != null) {
                                  ShareImage.shareImage(image);
                                }
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.orange,
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
            return Container(
              height: _deviceSize.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }
}
