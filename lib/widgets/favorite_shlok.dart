import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_hoon_arjun/providers/favorite.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import './shareImage.dart';
import './speaker_icon_button.dart';
import '../screens/desired_shlok_screen.dart';
import '../providers/playing_shlok.dart';

class FavoriteShlokItem extends StatefulWidget {
  final FavoriteItem favoriteShlok;
  final int shlokIndex;

  FavoriteShlokItem(this.favoriteShlok, this.shlokIndex);

  @override
  _FavoritesShlokState createState() => _FavoritesShlokState();
}

class _FavoritesShlokState extends State<FavoriteShlokItem> {
  final _controller = ScreenshotController();
  var firestore = FirebaseFirestore.instance;
  String shlokName;
  String url;

  @override
  void initState() {
    super.initState();
    shlokName = "Chap" +
        widget.favoriteShlok.chapter.substring(7) +
        '_' +
        widget.favoriteShlok.shlokNo +
        '.mp3';
    () {}();
  }

  Future<String> getshlokUrl() async {
    return await FirebaseStorage.instance
        .ref()
        .child('Shlok Audio Files')
        .child(widget.favoriteShlok.chapter)
        .child(shlokName)
        .getDownloadURL();
  }

  void _onTapShlok() async {
    SpeakerIcnBtn.player.stop();
    Provider.of<PlayingShlok>(context, listen: false)
        .setCurrentshlokPlaying(-1);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DesiredShlokScreen(
          shlokMap: widget.favoriteShlok,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Screenshot(
      controller: _controller,
      child: Card(
        margin: EdgeInsets.only(
          top: _deviceSize.height * 0.02, // 7.5,
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
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: _deviceSize.height * 0.012, // 10
                ),
                padding: EdgeInsets.only(
                  left: _deviceSize.width * 0.063, // 25
                  right: _deviceSize.width * 0.05, // 18
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.favoriteShlok.number,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final image = await _controller.capture();
                        if (image != null) {
                          ShareImage.shareImage(image);
                        }
                      },
                      child: Icon(
                        Icons.offline_share_rounded,
                        color: Colors.orange.shade800,
                        size: _deviceSize.height * 0.027,
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
                  ),
                  child: ShlokCard(
                    shlok: widget.favoriteShlok.shlok,
                    deviceSize: _deviceSize,
                  ),
                  width: double.infinity,
                ),
              ),
              SpeakerIcnBtn(
                audioUrl: getshlokUrl(),
                shlokIndex: widget.shlokIndex,
              )
            ],
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.065, //19,
          vertical: deviceSize.height * 0.01,
        ),
        height: deviceSize.height * 0.180, // 165
        alignment: Alignment.center,
        child: Text(
          shlok.trim(),
          style: TextStyle(
            fontSize: deviceSize.height * 0.025,
            color: Colors.orange.shade800,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
