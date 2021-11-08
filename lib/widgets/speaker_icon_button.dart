import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:main_hoon_arjun/providers/playing_shlok.dart';

class SpeakerIcnBtn extends StatefulWidget {
  SpeakerIcnBtn(this.shlokid);
  final String shlokid;
  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> {
  final AudioCache _audioCache = AudioCache();
  static AudioPlayer player;
  static bool isSoundOn = false;
  var isVolume = false;

  @override
  void initState() {
    super.initState();
    _audioCache.load('audio/karmanya-shlok.mp3');
  }

  @override
  void dispose() {
    super.dispose();
    player.stop();
  }

  void stopSound() {
    if (isSoundOn &&
        !(Provider.of<PlayingShlok>(context, listen: false)
                .getcureenshlokplaying() ==
            widget.shlokid)) {
      player.stop();
      isSoundOn = false;
      isVolume = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          stopSound();
          if (isVolume) {
            isVolume = !isVolume;
            Provider.of<PlayingShlok>(context, listen: false)
                .setcurrentshlokplaying(null);
          } else {
            isVolume = !isVolume;
            Provider.of<PlayingShlok>(context, listen: false)
                .setcurrentshlokplaying(widget.shlokid);
          }
          soundPlay();
        });
      },
      child: Consumer<PlayingShlok>(
        builder: (_, playingShlok, ch) {
          return playingShlok.getcureenshlokplaying() == widget.shlokid
              ? Icon(
                  isVolume ? Icons.pause_rounded : Icons.volume_up_rounded,
                  size: 25,
                  color: Colors.black87,
                )
              : const Icon(
                  Icons.volume_up_rounded,
                  size: 25,
                  color: Colors.black87,
                );
        },
      ),
    );
  }

  Future<void> soundPlay() async {
    if (isVolume) {
      isSoundOn = true;
      player = await _audioCache.play('audio/karmanya-shlok.mp3');
      player.onPlayerCompletion.listen((event) {
        setState(() {
          isVolume = false;
          isSoundOn = false;
        });
      });
    } else {
      player.stop();
      isSoundOn = false;
      isVolume = false;
    }
  }
}
