// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SettingsScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            "https://pbs.twimg.com/profile_images/843401950448111617/M_vs7v5C_400x400.jpg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
