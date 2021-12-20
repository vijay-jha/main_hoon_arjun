import 'package:flutter/material.dart';

import './speaker_icon_button.dart';
import '../screens/desired_shlok_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FavoriteShlokItem extends StatefulWidget {
  final Map<String, dynamic> shlok;
  final int shlokIndex;
  FavoriteShlokItem(this.shlok, this.shlokIndex);
  @override
  _FavoritesShlokState createState() => _FavoritesShlokState();
}

class _FavoritesShlokState extends State<FavoriteShlokItem> {
  String s;
  @override
  void initState() {
    super.initState();
    s = "Chap" +
        widget.shlok["Chapter"].toString().substring(7) +
        '_' +
        widget.shlok["hlok"].toString() +
        '.mp3';
  }

  Future<String> getshlokUrl() async {
    return (await FirebaseStorage.instance
        .ref()
        .child('Shlok Audio Files')
        .child(widget.shlok["Chapter"])
        .child(s)
        .getDownloadURL());
  }

  void _onTapShlok() async {
    print("chapterrrrrrrrr " + widget.shlok["Chapter"]);
    print("Chapterrrrrrrr->>>>>>> " + s);
    print(await getshlokUrl());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        top: 5,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
      child: Container(
        height: 267,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 0),
              padding: const EdgeInsets.only(
                left: 23,
                right: 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      widget.shlok["Number"],
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: _onTapShlok,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  top: 5,
                  right: 10,
                  bottom: 5,
                ),
                child: ShlokCard(shlok: widget.shlok["Shlok"]),
                width: double.infinity,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 55,
                right: 55,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // shlok numbering Lable
                  Container(
                    child: CommentsButton(),
                    alignment: Alignment.center,
                  ),

                  SpeakerIcnBtn(getshlokUrl(), widget.shlokIndex),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShlokCard extends StatelessWidget {
  ShlokCard({
    @required this.shlok,
  });

  final String shlok;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 23,
        ),
        height: 165,
        alignment: Alignment.center,
        child: Text(
          shlok.trim(),
          style: TextStyle(
            fontSize: 26,
            color: Colors.orange.shade700,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

class CommentsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 5),
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: const Icon(
          Icons.comment_rounded,
          color: Colors.black87,
          size: 28,
        ),
      ),
    );
  }
}
//  1. playing different from firestore
