import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../providers/playing_shlok.dart';

class SpeakerIcnBtn extends StatefulWidget {
  SpeakerIcnBtn({
    this.audioUrl,
    this.shlokIndex = 0,
    this.isDesired = false,
  });

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
    // () async {
    //   url = await widget.audioUrl;
    // }();
  }

  Widget playingAudio() {
    return FutureBuilder(
        future: SpeakerIcnBtn.player.setUrl(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();

          if (snapshot.hasData) {
            return StreamBuilder(
              stream: SpeakerIcnBtn.player.playerStateStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if (snapshot.hasData) {
                  final playerState = snapshot.data;

                  final processingState = playerState.processingState;
                  final playing = playerState.playing;

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
                }
                return CircularProgressIndicator();
              },
            );
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    var playingShlok = Provider.of<PlayingShlok>(context, listen: false);
    final _deviceSize = MediaQuery.of(context).size;

    void _onTap() {
      if (url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Audio is Loding. Please Try Again.',
              style: TextStyle(color: Colors.orange),
            ),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      if (playingShlok.getCureentShlokPlay() != widget.shlokIndex) {
        if (playingShlok.getCureentShlokPlay() != 0) {
          SpeakerIcnBtn.player.stop();
        }
        playingShlok.setCurrentshlokPlaying(widget.shlokIndex);
      } else {
        playingShlok.setCurrentshlokPlaying(0);
        SpeakerIcnBtn.player.stop();
      }
    }

    //
    return Card(
        elevation: widget.isDesired ? 10 : 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: InkWell(
          onTap: _onTap,
          child: Container(
            width: _deviceSize.width * 0.14,
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
            child: Provider.of<PlayingShlok>(context, listen: false)
                            .getCureentShlokPlay() ==
                        widget.shlokIndex &&
                    url != null
                ? playingAudio()
                : Icon(
                    Icons.volume_up_sharp,
                    color: Colors.orange.shade900,
                    size: _deviceSize.height * 0.038,
                  ),
          ),
        ));
  }
}
