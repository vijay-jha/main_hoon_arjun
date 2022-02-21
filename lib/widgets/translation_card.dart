// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TranslationCard extends StatefulWidget {
  TranslationCard({
    @required this.currentShlok,
    @required this.shlokNo,
    @required this.chapterNo,
  });

  final String currentShlok;
  final String shlokNo;
  final String chapterNo;

  @override
  State<TranslationCard> createState() => _TranslationCardState();
}

class _TranslationCardState extends State<TranslationCard> {
  var isTranslatedToEnglish = false;

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Geeta")
            .doc(widget.currentShlok.substring(0, 9))
            .get(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: _deviceSize.width * 0.09,
                  right: _deviceSize.width * 0.09,
                ),
                padding: EdgeInsets.all(30),
                width: double.infinity,
                // height: _deviceSize.height * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  snapshot.hasData
                      ? isTranslatedToEnglish
                          ? snapshot.data['Shlok${widget.shlokNo}']['translation']
                              ['english']
                          : snapshot.data['Shlok${widget.shlokNo}']['translation']
                              ['hindi']
                      : '''
........
........
........
........
          ''',
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              Positioned(
                bottom: _deviceSize.height * 0.01,
                right: _deviceSize.width * 0.09,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(15)),
                    color: Colors.orange.shade200,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isTranslatedToEnglish = !isTranslatedToEnglish;
                      });
                    },
                    icon: Icon(Icons.translate),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
