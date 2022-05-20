import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/helper/db_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MahabharatCharacters with ChangeNotifier {
  final List<Map<String, String>> _mahabharatCharacters = [
    {
      'name': 'Arjun',
      'link': 'assets/images/Arjun.png',
    },
    {
      'name': 'Draupadi',
      'link': 'assets/images/Draupadi.png',
    },
    {
      'name': 'Bhishma',
      'link': 'assets/images/Bhishma.png',
    },
    {
      'name': 'Dhritarashtra',
      'link': 'assets/images/Dhritarashtra.png',
    },
    {
      'name': 'Karn',
      'link': 'assets/images/Karn.png',
    },
    {
      'name': 'Duryodhan',
      'link': 'assets/images/Duryodhan.png',
    },
    {
      'name': 'Bheem',
      'link': 'assets/images/Bheem.png',
    },
    {
      'name': 'Dronacharya',
      'link': 'assets/images/Dronacharya.png',
    },
    {
      'name': 'Shakuni',
      'link': 'assets/images/Shakuni.png',
    },
  ];

  static int _currentAvatar = 0;

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

  int getCurrentAvatarIndex() {
    return _currentAvatar;
  }

  void currentAvatar(int index) async {
    _currentAvatar = index;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'avatarIndex': _currentAvatar});

    notifyListeners();
    DBHelper.update(
        'avatar_index', {'id': 1, 'ind': _currentAvatar}, 'id = ?', 1);
  }

  Future<void> fetchAvatarIndex() async {
    var dataSnapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    var data = dataSnapShot.data();
    _currentAvatar = data['avatarIndex'];
    notifyListeners();
  }

  void saveAvatarTolocal() {
    fetchAvatarIndex().then((_) {
      DBHelper.insert('avatar_index', {'id': 1, 'ind': _currentAvatar});
    });
  }

  Future<void> getIndexFromLocal() async {
    final avatarIndex = await DBHelper.getData('avatar_index');
    List<dynamic> gg = avatarIndex.map((e) => e['ind']).toList();
    _currentAvatar = gg[0];
    notifyListeners();
  }

  void deleteIndexFromLocal() {
    DBHelper.delete('avatar_index', 'id = ?', 1);
  }
}
