import 'package:flutter/material.dart';

class PlayingShlok with ChangeNotifier {
  String currentPlayingshlok;

  void setcurrentshlokplaying(String id) {
    currentPlayingshlok = id;
    notifyListeners();
  }

  String getcureenshlokplaying() {
    return currentPlayingshlok;
  }
}
