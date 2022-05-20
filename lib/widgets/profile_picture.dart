// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/mahabharat_characters.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({this.tag = 0});

  final tag;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return ProfilePictureDialog(
                avatarIndex:
                    Provider.of<MahabharatCharacters>(context, listen: true)
                        .getCurrentAvatarIndex(),
                username: "Mai Hoon Arjun", //i will put username here late
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          radius: 30,
          child: Image.asset(
            Provider.of<MahabharatCharacters>(context, listen: true)
                .getChosenAvatarLink(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ProfilePictureDialog extends StatelessWidget {
  ProfilePictureDialog({this.avatarIndex, this.username});

  final avatarIndex;
  final username;

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: _deviceSize.height * 0.446,
        decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.symmetric(horizontal: _deviceSize.width * 0.08),
        padding: EdgeInsets.fromLTRB(0, _deviceSize.height * 0.023, 0, 0),
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: _deviceSize.height * 0.352,
              child: Image.asset(
                Provider.of<MahabharatCharacters>(context, listen: true)
                    .getCharacterImageLink(avatarIndex),
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              height: _deviceSize.height * 0.0587,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              padding:
                  EdgeInsets.symmetric(vertical: _deviceSize.height * 0.0117),
              margin: EdgeInsets.fromLTRB(0, _deviceSize.height * 0.0117, 0, 0),
              alignment: Alignment.center,
              child: Text(
                username,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
