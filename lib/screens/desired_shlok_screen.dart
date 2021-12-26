// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/translation_card.dart';
import '../widgets/profile_picture.dart';
import '../widgets/shlok_card.dart';
import '../widgets/speaker_icon_button.dart';
import '../providers/playing_shlok.dart';

class DesiredShlokScreen extends StatefulWidget {
  static const routeName = '/desiredShlok-screen';

  @override
  State<DesiredShlokScreen> createState() => _DesiredShlokScreenState();
}

class _DesiredShlokScreenState extends State<DesiredShlokScreen> {
  final _controller = ScreenshotController();

  var shlok =
      """
                    कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।
मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥
                      """;
  var chapter = "Chap02";
  var shlokNo = "Shlok03";
  @override
  // void initState() async {
  //   super.initState();
  // }

  // statically playimg Chap02_Shlok03.mp3
  Future<String> getshlokUrl() async {
    return (await FirebaseStorage.instance
        .ref()
        .child('Shlok Audio Files')
        .child('Chapter02')
        .child('Chap02_Shlok03.mp3')
        .getDownloadURL());
  }

  @override
  void dispose() {
    super.dispose();
    SpeakerIcnBtn.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Screenshot(
      controller: _controller,
      child: ChangeNotifierProvider(
        create: (ctx) => PlayingShlok(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Shlok"),
            actions: [
              ProfilePicture(),
            ],
          ),
          body: ListView(
            children: [
              ShlokCard(shlok: shlok),
              SizedBox(
                height: _deviceSize.height * 0.05,
              ),
              // ChangeNotifierProvider(
              //   create: (ctx) => PlayingShlok(),
              //   child:
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: _deviceSize.width * 0.41),
                child: SpeakerIcnBtn(
                  audioUrl: getshlokUrl(),
                  shlokIndex: 0,
                ),
              ),
              // ),
              SizedBox(
                height: _deviceSize.height * 0.05,
              ),
              TranslationCard(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) async {
              if (index == 2) {
                final image = await _controller.capture();
                if (image != null) {
                  // await saveImage(image);
                  shareImage(image);
                }
              }
            },
            currentIndex: 1,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.comment),
                label: "Comments",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome),
                label: "Shlok",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.offline_share),
                label: "Share Shlok",
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade300,
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List imageBytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(imageBytes, name: name);
    return result['filePath'];
  }

  Future shareImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }
}
