import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/playing_shlok.dart';

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

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
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
            padding: EdgeInsets.symmetric(
                vertical: _deviceSize.height * 0.0089,
                horizontal: _deviceSize.width * 0.020),
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Provider.of<PlayingShlok>(
                      context,
                      listen: true,
                    ).getcureenshlokplaying() ==
                    widget.shlokIndex
                ? Future.delayed( const Duration(milliseconds: 5000),() {
                  const Icon(
                    Icons.pause_rounded,
                    size: 28,
                    color: Colors.black87,
                  );
                })  
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
