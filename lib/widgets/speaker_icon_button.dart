import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
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
    }();
  }

  Widget playingAudio() {
    Duration time;
    () async {
      time = await SpeakerIcnBtn.player.setAudioSource(
        AudioSource.uri(Uri.parse(url)),
      );
    }();

    return StreamBuilder(
        stream: SpeakerIcnBtn.player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering)
            return Container(
              width: 5,
              height: 5,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 3.0,
              ),
            );

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
        elevation: widget.isDesired ? 0 : 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                Radius.circular(10),
              ),
            ),
            child: Provider.of<PlayingShlok>(context, listen: true)
                        .getCureentShlokPlay() ==
                    widget.shlokIndex
                ? playingAudio()
                : Icon(
                    Icons.volume_up_sharp,
                    color: Colors.orange.shade900,
                    size: _deviceSize.height * 0.038,
                  ),
          ),
        ),
      );
    });
  }
}
