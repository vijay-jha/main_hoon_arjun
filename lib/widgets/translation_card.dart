// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TranslationCard extends StatefulWidget {
  const TranslationCard({Key key}) : super(key: key);

  @override
  State<TranslationCard> createState() => _TranslationCardState();
}

class _TranslationCardState extends State<TranslationCard> {
  var isTranslated = false;
  var hindiTranslation =
      """अर्थ: तेरा कर्म करने में ही अधिकार है, उसके फलों में कभी नहीं। इसलिए तू कर्मों के फल हेतु मत हो तथा तेरी कर्म न करने में भी आसक्ति न हो""";
  var englishTranslation =
      """Translation: You have every right to work but not expecting the fruits out of it.Let the focus be not on the fruits and never be inactive.""";
  var translation = "";

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: _deviceSize.width * 0.09,
            right: _deviceSize.width * 0.09,
          ),
          padding: EdgeInsets.all(30),
          width: double.infinity,
          height: _deviceSize.height * 0.3,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Text(
            translation.trim() == "" ? hindiTranslation : translation,
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
              color: Colors.orange.shade200,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isTranslated = !isTranslated;
                  translation =
                      isTranslated ? englishTranslation : hindiTranslation;
                });
              },
              icon: Icon(Icons.translate),
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
