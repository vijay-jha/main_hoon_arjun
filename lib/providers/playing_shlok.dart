import 'package:flutter/material.dart';

class PlayingShlok with ChangeNotifier {
  String currentPlayingshlok = null;

  void setcurrentshlokplaying(String id) {
    currentPlayingshlok = id;
    notifyListeners();
  }

  String getcureenshlokplaying() {
    return currentPlayingshlok;
  }
}
