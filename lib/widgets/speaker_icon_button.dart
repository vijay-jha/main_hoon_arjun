import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/playing_shlok.dart';

class SpeakerIcnBtn extends StatefulWidget {
  const SpeakerIcnBtn({
    Key key,
    this.audioUrl,
    this.shlokIndex,
    this.isDesired = false,
  }) : super(key: key);

  final bool isDesired;
  final int shlokIndex;
  final Future<String> audioUrl;
  static AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    var playingShlok = Provider.of<PlayingShlok>(context, listen: false);
    final _deviceSize = MediaQuery.of(context).size;

    void _onTap() {
      if (playingShlok.getcureenshlokplaying() != widget.shlokIndex) {
        playingShlok.setcurrentshlokplaying(widget.shlokIndex);
        SpeakerIcnBtn.player.stop();
        soundPlay();
      } else {
        playingShlok.setcurrentshlokplaying(-1);
        SpeakerIcnBtn.player.stop();
      }
    }

    return InkWell(
      onTap: _onTap,
      child: Consumer<PlayingShlok>(
        builder: (_, playingShlok, ch) {
          return Card(
            elevation: widget.isDesired ? 4 : 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Container(
              width: 55,
              padding: EdgeInsets.symmetric(
                vertical: _deviceSize.height * 0.0089,
                horizontal: _deviceSize.width * 0.020,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Provider.of<PlayingShlok>(
                        context,
                        listen: true,
                      ).getcureenshlokplaying() ==
                      widget.shlokIndex
                  ? isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : const Icon(
                          Icons.pause_rounded,
                          size: 33,
                          color: Colors.black87,
                        )
                  : const Icon(
                      Icons.volume_up_rounded,
                      size:  33,
                      color: Colors.black87,
                    ),
            ),
          );
        },
      ),
    );
  }

  void soundPlay() {
    int result;
    setState(() {
      isLoading = true;
    });

    () async {
      String url = await widget.audioUrl;
      result = await SpeakerIcnBtn.player.play(
        url,
      );
    }()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    if (result == 1) {
      SpeakerIcnBtn.player.onPlayerCompletion.listen((event) {
        Provider.of<PlayingShlok>(context, listen: false)
            .setcurrentshlokplaying(-1);
        SpeakerIcnBtn.player.stop();
      });
    }
  }
}
