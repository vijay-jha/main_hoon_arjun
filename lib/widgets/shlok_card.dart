// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShlokCard extends StatefulWidget {
  ShlokCard({
    @required this.currentShlok,
    @required this.isFavorite,
    @required this.toggleFavorite,
    @required this.shlokNo,
    @required this.chapterNo,
  });

  final String currentShlok;
  final String shlokNo;
  final String chapterNo;
  final Function toggleFavorite;
  bool isFavorite;

  @override
  State<ShlokCard> createState() => _ShlokCardState();
}

class _ShlokCardState extends State<ShlokCard> {
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
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.only(
                  top: _deviceSize.height * 0.07,
                  left: _deviceSize.width * 0.09,
                  right: _deviceSize.width * 0.09,
                ),
                child: shlokCard(_deviceSize, snapshot),
              ),
              Positioned(
                top: _deviceSize.height * 0.04,
                right: _deviceSize.width * 0.04,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.toggleFavorite();
                        widget.isFavorite = !widget.isFavorite;
                      });
                    },
                    icon: Icon(widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Container shlokCard(Size _deviceSize, AsyncSnapshot snapshot) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(17),
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          vertical: _deviceSize.height * 0.05,
          horizontal: _deviceSize.width * 0.09,
        ),
        child: Text(
          snapshot.hasData
              ? snapshot.data['Shlok${widget.shlokNo}']['text']
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
    );
  }
}
