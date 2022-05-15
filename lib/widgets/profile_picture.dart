// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/mahabharat_characters.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({this.tag = 0});
  final tag;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class ProfilePictureDialog extends StatefulWidget {
  const ProfilePictureDialog({this.uid, this.index, this.username});
  final uid;
  final index;
  final username;

  @override
  State<ProfilePictureDialog> createState() => _ProfilePictureDialogState();
}

class _ProfilePictureDialogState extends State<ProfilePictureDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInBack);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: 371,
        decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: 300,
              child: Image.asset(
                Provider.of<MahabharatCharacters>(context, listen: true)
                    .getByIndex(widget.index),
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              alignment: Alignment.center,
              child: Text(
                widget.username,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
