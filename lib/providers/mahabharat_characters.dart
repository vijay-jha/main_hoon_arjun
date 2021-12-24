import 'package:flutter/material.dart'; 

class MahabharatCharacters with ChangeNotifier {
  final List<Map<String, String>> _mahabharatCharacters = [
    {
      'name': 'Arjun',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/arjun-standing-in-welcome-pose-3247069-2706135.png',
    },
    {
      'name': 'Draupadi',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/draupadi-holding-worship-plate-3220909-2703406.png',
    },
    {
      'name': 'Bhishma',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/bhishma-pitamaha-3247112-2706051.png',
    },
    {
      'name': 'Dhritarashtra',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/king-dhritarashtra-3247180-2706118.png',
    },
    {
      'name': 'Karan',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/karna-removing-his-crown-3220949-2694481.png',
    },
    {
      'name': 'Duryodhan',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/angry-duryodhana-3220998-2694531.png',
    },
    {
      'name': 'Bheem',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/bheem-standing-in-welcome-pose-3247133-2706072.png',
    },
    {
      'name': 'Dronacharya',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/dronacharya-standing-in-namaste-pose-3220920-2703417.png',
    },
    {
      'name': 'Shakuni',
      'link':
          'https://cdni.iconscout.com/illustration/premium/thumb/shakuni-standing-in-welcome-pose-3260304-2726033.png',
    },
  ];

  int _currentAvatar = 0;

  List<Map<String, String>> get mahabharatCharacters {
    return [..._mahabharatCharacters];
  }

  String getCharacterName(int index) {
    return _mahabharatCharacters[index]['name'];
  }

  String getCharacterImageLink(int index) {
    return _mahabharatCharacters[index]['link'];
  }

  String getChosenAvatarLink() {
    return _mahabharatCharacters[_currentAvatar]['link'];
  }

  String getChosenAvatarName() {
    return _mahabharatCharacters[_currentAvatar]['name'];
  }

  void currentAvatar(int index) {
    _currentAvatar = index;
    notifyListeners();
  }
}
