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

  final isDesired;
  final int shlokIndex;
  final Future<String> audioUrl;
  static AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  @override
  _SpeakerIcnBtnState createState() => _SpeakerIcnBtnState();
}

class _SpeakerIcnBtnState extends State<SpeakerIcnBtn> {
  bool isLoading = false;
  String url;
  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    url = await widget.audioUrl;
  }

  // void soundPlay() {
  //   int result;
  //   setState(() {
  //     isLoading = true;
  //   });

  //   () async {
  //     // String url = await widget.audioUrl;
  //     result = await SpeakerIcnBtn.player.play(
  //       url,
  //     );
  //   }()
  //       .then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return null;
  //   });

  //   if (result == 1) {
  //     SpeakerIcnBtn.player.onPlayerCompletion.listen((event) {
  //       Provider.of<PlayingShlok>(context, listen: false)
  //           .setCurrentshlokPlaying(-1);
  //       SpeakerIcnBtn.player.stop();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var playingShlok = Provider.of<PlayingShlok>(context, listen: false);
    final _deviceSize = MediaQuery.of(context).size;

    bool isOn = false;

    // void _onTap() {
    // if (playingShlok.getCureentShlokPlay() != widget.shlokIndex) {
    //   playingShlok.setCurrentshlokPlaying(widget.shlokIndex);
    //   SpeakerIcnBtn.player.stop();
    //   soundPlay();
    // } else {
    //   playingShlok.setCurrentshlokPlaying(-1);
    //   SpeakerIcnBtn.player.stop();
    // }
    // }

    // return InkWell(
    //   onTap: _onTap,
    //   child: Consumer<PlayingShlok>(
    //     builder: (_, playingShlok, ch) {
    //       return Card(
    //         elevation: widget.isDesired ? 4 : 0,
    //         shape: const RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(25)),
    //         ),
    //         child: Container(
    //           width: 55,
    //           padding: EdgeInsets.symmetric(
    //             vertical: _deviceSize.height * 0.0089,
    //             horizontal: _deviceSize.width * 0.020,
    //           ),
    //           decoration: BoxDecoration(
    //             color: Colors.orange.shade100,
    //             borderRadius: const BorderRadius.all(
    //               Radius.circular(25),
    //             ),
    //           ),
    //           child: Provider.of<PlayingShlok>(
    //                     context,
    //                     listen: true,
    //                   ).getCureentShlokPlay() ==
    //                   widget.shlokIndex
    //               ? isLoading
    //                   ? const CircularProgressIndicator(
    //                       color: Colors.orange,
    //                     )
    //                   : const Icon(
    //                       Icons.pause_rounded,
    //                       size: 33,
    //                       color: Colors.black87,
    //                     )
    //               : const Icon(
    //                   Icons.volume_up_rounded,
    //                   size: 33,
    //                   color: Colors.black87,
    //                 ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    return InkWell(
      onTap: () {
        if (playingShlok.getCureentShlokPlay() != widget.shlokIndex) {
          SpeakerIcnBtn.player.stop();
          playingShlok.setCurrentshlokPlaying(widget.shlokIndex);
        } else {
          playingShlok.setCurrentshlokPlaying(-1);
          SpeakerIcnBtn.player.stop();
        }
        setState(() {
          isOn = !isOn;
        });
      },
      child: Card(
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
          child: Consumer<PlayingShlok>(
            builder: (_, playingShlok, ch) {
              return isOn
                  ? FutureBuilder(
                      future: SpeakerIcnBtn.player.play(
                        url,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return StreamBuilder(
                                stream: SpeakerIcnBtn.player.onPlayerCompletion,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Icon(
                                        Icons.pause_circle_outline_rounded);
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    playingShlok.setCurrentshlokPlaying(-1);
                                    return Icon(Icons.volume_up_sharp);
                                  }
                                  return Center();
                                });
                          }
                        } else {
                          return Icon(Icons.volume_up_sharp);
                        }
                        return Center();
                      },
                    )
                  :
                  Icon(Icons.volume_up_sharp);
            },
          ),
        ),
      ),
    );
  }
}
