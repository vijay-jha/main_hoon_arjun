import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import './speaker_icon_button.dart';
import '../screens/desired_shlok_screen.dart';
import '../providers/playing_shlok.dart';

class FavoriteShlokItem extends StatefulWidget {
  final Map<String, dynamic> shlok;
  final int shlokIndex;
  FavoriteShlokItem(this.shlok, this.shlokIndex);
  @override
  _FavoritesShlokState createState() => _FavoritesShlokState();
}

class _FavoritesShlokState extends State<FavoriteShlokItem> {
  var firestore = FirebaseFirestore.instance;
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
    SpeakerIcnBtn.player.stop();
    Provider.of<PlayingShlok>(context, listen: false)
        .setcurrentshlokplaying(-1);
    Navigator.of(context).pushNamed(DesiredShlokScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.only(
        top: _deviceSize.height * 0.02, //7.5,
        bottom: _deviceSize.height * 0.008, // 7.5
        left: _deviceSize.width * 0.025, // 10
        right: _deviceSize.width * 0.025, // 10
      ),
      color: Colors.orange.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
      child: Container(
        // height: _deviceSize.height * 0.300, //240
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.only(
                top: _deviceSize.height * 0.009, // 10
                bottom: 0,
              ),
              padding: EdgeInsets.only(
                left: _deviceSize.width * 0.063, // 25
                right: _deviceSize.width * 0.040, // 18
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.shlok["Number"],
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600),
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
                margin: EdgeInsets.only(
                  left: _deviceSize.width * 0.035, //14
                  top: _deviceSize.height * 0.005, //5,
                  right: _deviceSize.width * 0.035, //14
                  bottom: _deviceSize.height * 0.005, //5,
                ),
                child: ShlokCard(
                  shlok: widget.shlok["Shlok"],
                  deviceSize: _deviceSize,
                ),
                width: double.infinity,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: _deviceSize.width * 0.140, // 55
                right: _deviceSize.width * 0.140, // 55
                bottom: _deviceSize.height * 0.009, //6
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // shlok numbering Lable
                  Container(
                    child: CommentsButton(deviceSize: _deviceSize),
                    alignment: Alignment.center,
                  ),

                  SpeakerIcnBtn(
                    audioUrl: getshlokUrl(),
                    shlokIndex: widget.shlokIndex,
                  ),
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
  ShlokCard({@required this.shlok, this.deviceSize});

  final String shlok;
  final deviceSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.048, //19,
        ),
        height: deviceSize.height * 0.180, // 165
        alignment: Alignment.center,
        child: Text(
          shlok.trim(),
          style: TextStyle(
            fontSize: deviceSize.height * 0.029,
            color: Colors.orange.shade800,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

class CommentsButton extends StatelessWidget {
  CommentsButton({this.deviceSize});
  final deviceSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: deviceSize.width * 0.140, // 55
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          top: deviceSize.height * 0.009, // 8
          right: deviceSize.width * 0.020, //8,
          left: deviceSize.width * 0.020, //8,
          bottom: deviceSize.height * 0.005, //5,
        ),
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
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
