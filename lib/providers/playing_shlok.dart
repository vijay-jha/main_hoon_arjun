import 'package:flutter/material.dart';

class PlayingShlok with ChangeNotifier {
  int currentPlayingshlok = -1;

  void setcurrentshlokplaying(int id) {
    currentPlayingshlok = id;
    notifyListeners();
  }

  int getcureenshlokplaying() {
    return currentPlayingshlok;
  }

  bool isSefPlaying(int id) {
    if (currentPlayingshlok == id) {
      return true;
    }
    return false;
  }
}
