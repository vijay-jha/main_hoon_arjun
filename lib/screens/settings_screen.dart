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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, DisplayAvatar.routeName);
                        },
                        child: CircleAvatar(
                          radius: 70,
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
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                const SizedBox(
                  height: 50,
                ),
                choice(context, 'Username', snapshot),
                choice(context, 'Avatar', snapshot),
                choice(context, 'About', snapshot),
                const Divider(),
                const SizedBox(
                  height: 50,
                ),
                // const Divider(),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
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
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  InkWell choice(BuildContext ctx, String choice, AsyncSnapshot snapshot) {
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
              context: ctx,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey.shade300),
          border: Border(
            bottom: BorderSide.none,
            top: BorderSide(
              width: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              choice,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
