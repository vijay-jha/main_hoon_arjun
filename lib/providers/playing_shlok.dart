import 'package:flutter/material.dart';

class PlayingShlok with ChangeNotifier {
  int currentPlayingshlok = -1;

  void setCurrentshlokPlaying(int id) {
    currentPlayingshlok = id;
    notifyListeners();
  }

  int getCureentShlokPlay() {
    return currentPlayingshlok;
  }

  void noOnePlaying() {
    currentPlayingshlok = -1;
  }
}
