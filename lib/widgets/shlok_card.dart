import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShlokCard extends StatefulWidget {
  ShlokCard({
    @required this.shlok,
  });

  final String shlok;

  @override
  State<ShlokCard> createState() => _ShlokCardState();
}

class _ShlokCardState extends State<ShlokCard> {
  /*
  void _onDoubleTapShlok() async {
    for (int i = 0; i < geeta.length; i++) {
      await FirebaseFirestore.instance
          .collection('Geeta')
          .doc('Chapter${geeta[i]["chapter"]}')
          .update({
        'Shlok${geeta[i]["shlok"]}': {
          'chapter': geeta[i]["chapter"],
          'shlok': geeta[i]["shlok"],
          'text': geeta[i]["text"],
          'translation': {
            'english': geeta[i]["translation-eng"],
            'hindi': geeta[i]["translation-hin"],
          },
          'meaning': {
            'english': geeta[i]["meaning-eng"],
            'hindi': geeta[i]["meaning-hin"],
          }
        }
      });
      print("iiiiiiiiiiiiiiii = " + i.toString());
    }
  }
  */
  bool isFavorite = false;

  @override
  Future<void> dispose() async {
    super.dispose();
    final _user = FirebaseAuth.instance.currentUser;
    String currentShlok = 'chapter02_shlok03';

    var doc = await FirebaseFirestore.instance
        .collection('user_favorites')
        .doc(_user.uid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('user_favorites')
          .doc(_user.uid)
          .set({
        'fav_sholks': [currentShlok]
      });
    } else {
      var data = doc.data();
      var favoriteShloks = data['fav_sholks'];
      if (isFavorite) {
        if (!favoriteShloks.contains(currentShlok)) {
          favoriteShloks.add(currentShlok);
          await FirebaseFirestore.instance
              .collection('user_favorites')
              .doc(_user.uid)
              .set({'fav_sholks': favoriteShloks});
        }
      } else {
        favoriteShloks.remove(currentShlok);
        await FirebaseFirestore.instance
            .collection('user_favorites')
            .doc(_user.uid)
            .set({'fav_sholks': favoriteShloks});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

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
          child: shlokCard(_deviceSize),
        ),
        Positioned(
          top: _deviceSize.height * 0.04,
          right: _deviceSize.width * 0.04,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Container shlokCard(Size _deviceSize) {
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
          widget.shlok.trim(),
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
