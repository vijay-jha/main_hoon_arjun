// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/settings_screen.dart';
import '../providers/mahabharat_characters.dart';

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SettingsScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 27,
          child: Image.network(
            // "https://pbs.twimg.com/profile_images/843401950448111617/M_vs7v5C_400x400.jpg",
            Provider.of<MahabharatCharacters>(context, listen: false)
                .getChosenAvatarLink(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
