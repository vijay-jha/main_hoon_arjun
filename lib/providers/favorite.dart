import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoriteItem {
  final String shlok;
  final String number;
  final String chapter;
  final String shlokNo;

  FavoriteItem({
    this.shlok,
    this.number,
    this.chapter,
    this.shlokNo,
  });
}

class FavoritesShlok with ChangeNotifier {
  List<FavoriteItem> _shlok = [];

  Future<void> fetchFavoriteShlok(var userFavorite) async {
    List<FavoriteItem> shlok = [];
    var currentChapter = null;
    var allShloksFromChapter = null;

    final _user = FirebaseAuth.instance.currentUser;

    var data = userFavorite.data();
    var favoriteShloks = data['fav_sholks'];

    for (int i = 0; i < favoriteShloks.length; i++) {
      var favorite = favoriteShloks[i];
      var chapterAndShlok = favorite.split('_');

      if (currentChapter != chapterAndShlok[0]) {
        currentChapter = chapterAndShlok[0];
        allShloksFromChapter = await FirebaseFirestore.instance
            .collection('Geeta')
            .doc(chapterAndShlok[0])
            .get();
      }

      var particularShlok = allShloksFromChapter[chapterAndShlok[1]];
      
      shlok.add(
        FavoriteItem(
            shlok: particularShlok['text'],
            number:
                "अ.${chapterAndShlok[0].substring(7)}, श्लोक.${chapterAndShlok[1].substring(5)}",
            chapter: chapterAndShlok[0],
            shlokNo: chapterAndShlok[1]),
      );
    }
    _shlok = shlok;
    notifyListeners();
  }

  List shloks() {
    return _shlok;
  }
}
