// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/translation_card.dart';
import '../widgets/profile_picture.dart';
import '../widgets/shlok_card.dart';

class DesiredShlokScreen extends StatefulWidget {
  static const routeName = '/desiredShlok-screen';

  @override
  State<DesiredShlokScreen> createState() => _DesiredShlokScreenState();
}

class _DesiredShlokScreenState extends State<DesiredShlokScreen> {
  final AudioCache _audioCache = AudioCache();
  final _controller = ScreenshotController();

  AudioPlayer player;

  var isVolume = false;
  var shlok = """
                    कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।
मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥
                      """;

  var _currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    _audioCache.load('audio/karmanya-shlok.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _controller,
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
            speakerButtton(),
            TranslationCard(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) async {
            setState(() {
              _currentPageIndex = index;
            });
            if (_currentPageIndex == 2) {
              final image = await _controller.capture();
              if (image != null) {
                // await saveImage(image);
                saveAndShare(image);
              }
            }
          },
          currentIndex: _currentPageIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Comment"),
            BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome), label: "Shlok"),
            BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share"),
          ],
        ),
        backgroundColor: Colors.orange.shade300,
      ),
    );
  }

  IconButton speakerButtton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isVolume = !isVolume;
          soundPlay();
        });
      },
      icon: Icon(isVolume ? Icons.volume_mute : Icons.volume_up),
      iconSize: 50,
      color: Colors.white,
    );
  }

  Future<void> soundPlay() async {
    if (isVolume) {
      player = await _audioCache.play('audio/karmanya-shlok.mp3');
      player.onPlayerCompletion.listen((event) {
        setState(() {
          isVolume = false;
        });
      });
    } else {
      player.stop();
    }
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

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }
}
