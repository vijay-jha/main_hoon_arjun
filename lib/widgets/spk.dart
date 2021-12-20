import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SpeakerIcnBtn extends StatefulWidget {
  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> {
  final AudioCache _audioCache = AudioCache();
  AudioPlayer player;

  var isVolume = false;
  @override
  void initState() {
    super.initState();
    _audioCache.load('audio/karmanya-shlok.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isVolume = !isVolume;
          soundPlay();
        });
      },
      icon: Icon(isVolume ? Icons.pause_rounded : Icons.volume_up_rounded),
      iconSize: 25,
      color: Colors.black87,
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
}
