import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoritesShlok with ChangeNotifier {
  List<Map<String, dynamic>> _shlok = [];

  Future<void> fetchFavoriteShlok(var userFavorite) async {
    List<Map<String, dynamic>> shlok = [];

    final _user = FirebaseAuth.instance.currentUser;

    var data = userFavorite.data();
    var favoriteShloks = data['fav_sholks'];

    for (int i = 0; i < favoriteShloks.length; i++) {
      var favorite = favoriteShloks[i];
      var chapterAndShlok = favorite.split('_');
      var allShloksFromChapter = await FirebaseFirestore.instance
          .collection('Geeta')
          .doc(chapterAndShlok[0])
          .get();

      var particularShlok = allShloksFromChapter[chapterAndShlok[1]];

      shlok.add({
        "Shlok": particularShlok['text'],
        "Number":
            "अ.${chapterAndShlok[0].substring(7)}, श्लोक.${chapterAndShlok[1].substring(5)}",
        "Chapter": chapterAndShlok[0],
        "ShlokNo": chapterAndShlok[1],
      });
    }
    _shlok = shlok;
    notifyListeners();
  }

  List shlok() {
    return _shlok;
  }
}
