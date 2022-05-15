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
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.only(
                  left: _deviceSize.width * 0.08,
                  right: _deviceSize.width * 0.08,
                  bottom: _deviceSize.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 53),
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
                            ? snapshot.data['Shlok${widget.shlokNo}']
                                    ['translation']['english']
                                .toString()
                                .trim()
                            : snapshot.data['Shlok${widget.shlokNo}']
                                    ['translation']['hindi']
                                .toString()
                                .trimLeft()
                        : '''
              ........
              ........
              ........
              ........
                        ''',
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              Positioned(
                bottom: _deviceSize.height * 0.047,
                left: _deviceSize.width * 0.13,
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(left: 10, bottom: 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
