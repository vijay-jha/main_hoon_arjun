import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

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
  static AudioPlayer player;

  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> {
  String url;

  @override
  void initState() {
    super.initState();
    SpeakerIcnBtn.player = AudioPlayer();
    () async {
      url = await widget.audioUrl;
      // final duration = await SpeakerIcnBtn.player.setUrl(url);
    }();
  }

  Widget playingAudio() {
    return FutureBuilder(
        future: SpeakerIcnBtn.player.setUrl(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          return StreamBuilder(
              stream: SpeakerIcnBtn.player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering)
                  return CircularProgressIndicator();
                if (playing != true) {
                  SpeakerIcnBtn.player.play();
                } else if (processingState == ProcessingState.ready) {
                  return Icon(
                    Icons.pause_circle_outline_rounded,
                    color: Colors.orange.shade900,
                    size: 33,
                  );
                } else if (playing == true &&
                    processingState == ProcessingState.idle) {
                  SpeakerIcnBtn.player.dispose();
                  SpeakerIcnBtn.player = AudioPlayer();
                  return playingAudio();
                }
                return Icon(
                  Icons.pause_circle_outline_rounded,
                  color: Colors.orange.shade900,
                  size: 33,
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    var playingShlok = Provider.of<PlayingShlok>(context, listen: false);
    final _deviceSize = MediaQuery.of(context).size;

void _onTap() {
      if (playingShlok.getCureentShlokPlay() != widget.shlokIndex) {
        SpeakerIcnBtn.player.stop();
        playingShlok.setCurrentshlokPlaying(widget.shlokIndex);
      } else {
        playingShlok.setCurrentshlokPlaying(-1);
        SpeakerIcnBtn.player.stop();
      }
    }

    return Consumer<PlayingShlok>(builder: (_, playingShlok, ch) {
      return Card(
        elevation: widget.isDesired ? 4 : 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: InkWell(
          onTap: _onTap,
          child: Container(
            width: 55,
            padding: EdgeInsets.symmetric(
              vertical: _deviceSize.height * 0.0089,
              horizontal: _deviceSize.width * 0.020,
            ),
            decoration: BoxDecoration(
              color: widget.isDesired
                  ? Colors.orange.shade100
                  : Colors.orange.shade200,
              //  border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Provider.of<PlayingShlok>(context, listen: true)
                        .getCureentShlokPlay() ==
                    widget.shlokIndex
<<<<<<< HEAD
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
=======
                ? playingAudio()
                : Icon(
                    Icons.volume_up_sharp,
                    color: Colors.orange.shade900,
                    size: 33,
>>>>>>> c72845b4d9e13d93dff8eb2147caa8a36e376b59
                  ),
          ),
        ),
      );
    });
  }
}
