import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:main_hoon_arjun/providers/playing_shlok.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SpeakerIcnBtn extends StatefulWidget {
  const SpeakerIcnBtn(this.audioUrl, this.shlokIndex);
  final int shlokIndex;
  final Future<String> audioUrl;

  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> with Exception {
  // final AudioCache _audioCache = AudioCache();
  static AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  @override
  void initState() {
    super.initState();

    // _audioUrl = await audioRef.getDownloadURL();
    // _audioCache.load("audio/karmanya-shlok.mp3");
  }

  @override
  void dispose() {
    super.dispose();
    if (player != null) {
      // if (Provider.of<PlayingShlok>(context, listen: false)
      //         .getcureenshlokplaying() ==
      //     widget.shlokIndex) {
      //   Provider.of<PlayingShlok>(context, listen: false)
      //       .setcurrentshlokplaying(-1);
      player.stop();
      // }
    }
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
          player.stop();
          soundPlay();
        } else {
          Provider.of<PlayingShlok>(context, listen: false)
              .setcurrentshlokplaying(-1);
          player.stop();
        }
      },
      child: Consumer<PlayingShlok>(
        builder: (_, playingShlok, ch) {
          return Container(
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
    Exception exception;
    String url = await widget.audioUrl;

    result = await player.play(
      url,
    );

    if (result == 1) {
      player.onPlayerCompletion.listen((event) {
        Provider.of<PlayingShlok>(context, listen: false)
            .setcurrentshlokplaying(-1);
        player.stop();
      });
    }
  }
}
