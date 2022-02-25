// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './about_screen.dart';
import '../screens/choose_avatar_screen.dart';
import '../screens/signout_splash_screen.dart';
import '../providers/mahabharat_characters.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      backgroundColor: Colors.orange.shade50,
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView(
              children: [
                SizedBox(
                  height: _deviceSize.height * 0.07, // 50
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, DisplayAvatar.routeName);
                        },
                        child: CircleAvatar(
                          radius: _deviceSize.width * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset(
                              Provider.of<MahabharatCharacters>(context)
                                  .getChosenAvatarLink(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _deviceSize.height * 0.03),
                        child: Text(
                          snapshot.hasData ? snapshot.data['username'] : "",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.orange.shade100,
                  padding: EdgeInsets.all(_deviceSize.width * 0.005),
                  margin: EdgeInsets.only(
                    top: _deviceSize.height * 0.01,
                    bottom: _deviceSize.height * 0.002,
                  ),
                  child: Column(
                    children: [
                      choice(context, 'Username', snapshot, _deviceSize),
                      choice(context, 'Avatar', snapshot, _deviceSize),
                      choice(context, 'About', snapshot, _deviceSize),
                    ],
                  ),
                ),
                SizedBox(
                  height: _deviceSize.height * 0.05,
                ),
                Container(
                  color: Colors.orange.shade100,
                  padding: EdgeInsets.symmetric(
                      horizontal: _deviceSize.width * 0.015),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.orange.shade50,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Sign Out"),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                          content: Text("Do you really want to Sign out?"),
                          actions: [
                            OutlinedButton(
                                onPressed: () async {
                                  await Future.delayed(
                                      Duration(milliseconds: 200));
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            OutlinedButton(
                                onPressed: () async {
                                  await Future.delayed(
                                      Duration(milliseconds: 200));
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(
                                      context, SignOutSplashScreen.routeName);
                                },
                                child: Text("Sign Out")),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign out',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.orange.shade700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.orange.shade700,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  InkWell choice(BuildContext ctx, String choice, AsyncSnapshot snapshot,
      var _deviceSize) {
    final _usernameController = TextEditingController();
    if (snapshot.hasData) {
      _usernameController.text = snapshot.data['username'];
    } else {
      _usernameController.text = "";
    }

    return InkWell(
      onTap: () {
        if (choice == "About") {
          Navigator.pushNamed(ctx, AboutScreen.routeName);
        } else if (choice == "Avatar") {
          Navigator.pushNamed(ctx, DisplayAvatar.routeName);
        } else {
          showModalBottomSheet(
              backgroundColor: Colors.orange.shade50,
              context: ctx,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: _deviceSize.height * 0.02,
                          right: _deviceSize.width * 0.05,
                          left: _deviceSize.width * 0.05),
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                        ),
                        autofocus: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_usernameController.text.isNotEmpty) {
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update(
                                        {"username": _usernameController.text});
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: _deviceSize.height * 0.018,
            horizontal: _deviceSize.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              choice,
              style: TextStyle(fontSize: 20, color: Colors.orange.shade700),
            ),
            choice == 'Username'
                ? Icon(
                    Icons.edit,
                    color: Colors.orange.shade700,
                  )
                : choice == 'Avatar'
                    ? Icon(
                        Icons.person_outlined,
                        color: Colors.orange.shade700,
                      )
                    : Icon(
                        Icons.chevron_right,
                        color: Colors.orange.shade700,
                      ),
          ],
        ),
      ),
    );
  }
}
