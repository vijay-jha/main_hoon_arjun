import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:main_hoon_arjun/providers/playing_shlok.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SpeakerIcnBtn extends StatefulWidget {
  const SpeakerIcnBtn({
    Key key,
    this.audioUrl,
    this.shlokIndex,
  }) : super(key: key);

  final int shlokIndex;
  final Future<String> audioUrl;
  static AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> with Exception {
  @override
  void initState() {
    super.initState();
    // _audioUrl = await audioRef.getDownloadURL();
    // _audioCache.load("audio/karmanya-shlok.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Provider.of<PlayingShlok>(context, listen: false)
                .getcureenshlokplaying() !=
            widget.shlokIndex) {
          Provider.of<PlayingShlok>(context, listen: false)
              .setcurrentshlokplaying(widget.shlokIndex);

          SpeakerIcnBtn.player.stop();
          soundPlay();
        } else {
          Provider.of<PlayingShlok>(context, listen: false)
              .setcurrentshlokplaying(-1);
          SpeakerIcnBtn.player.stop();
        }
      },
      child: Consumer<PlayingShlok>(
        builder: (_, playingShlok, ch) {
          return Container(
            width: 55,
            padding: EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Provider.of<PlayingShlok>(
                      context,
                      listen: true,
                    ).getcureenshlokplaying() ==
                    widget.shlokIndex
                ? const Icon(
                    Icons.pause_rounded,
                    size: 28,
                    color: Colors.black87,
                  )
                : const Icon(
                    Icons.volume_up_rounded,
                    size: 28,
                    color: Colors.black87,
                  ),
          );
        },
      ),
    );
  }

  Future<void> soundPlay() async {
    int result;
    String url = await widget.audioUrl;

    result = await SpeakerIcnBtn.player.play(
      url,
    );

    if (result == 1) {
      SpeakerIcnBtn.player.onPlayerCompletion.listen((event) {
        Provider.of<PlayingShlok>(context, listen: false)
            .setcurrentshlokplaying(-1);
        SpeakerIcnBtn.player.stop();
      });
    }
  }
}
