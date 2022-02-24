import 'package:flutter/foundation.dart';

class Translation with ChangeNotifier {
  bool isEnglish = false;

  toggleTranslation() {
    isEnglish = !isEnglish;
    notifyListeners();
  }

  bool getIsEnglish() {
    return isEnglish;
  }
}
