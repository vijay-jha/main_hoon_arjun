import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookmarkShlok with ChangeNotifier{
  List<Map<String, dynamic>> _shlok = [];

  Future<void> fetchBookmarkShlok(var userBookmark) async {
    List<Map<String, dynamic>> shlok = [];

    final _user = FirebaseAuth.instance.currentUser;

    var data = userBookmark.data();
    var bookmarkShloks = data['bookmarked_shloks'];

    for (int i = 0; i < bookmarkShloks.length; i++) {
      var bookmark = bookmarkShloks[i];
      var chapterAndShlok = bookmark.split('_');
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