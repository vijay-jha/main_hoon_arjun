// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:convert';

import './desired_shlok_screen.dart';
import '../widgets/profile_picture.dart';
import '../api.dart' as api;
import '../constants.dart' show FEELING_API;

class HomepageScreen extends StatefulWidget {
  static const routeName = '/homepage-screen';
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen>
    with TickerProviderStateMixin {
  FocusNode inputNode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Hoon Arjun"),
        actions: [ProfilePicture()],
      ),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: TextField(
            onSubmitted: (feeling) async {
              FocusScope.of(context).unfocus();
              await Future.delayed(const Duration(milliseconds: 500), () {});
              setState(() {
                isLoading = true;
              });
              if (feeling.isNotEmpty) {
                var url = Uri.parse('$FEELING_API/feeling?query=' + feeling);
                var data = await api.getData(url);
                var decodedData = json.decode(data);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DesiredShlokScreen(emotions: decodedData),
                  ),
                );
                setState(() {
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.orange.shade50,
                    content: Text("Please enter something about your feeling."),
                    actions: [
                      OutlinedButton(
                          onPressed: () async {
                            await Future.delayed(Duration(milliseconds: 200));
                            Navigator.of(context).pop();
                          },
                          child: Text("Okay")),
                    ],
                  ),
                );
              }
            },
            focusNode: inputNode,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: "How you are feeling today?",
              hintStyle: TextStyle(color: Colors.blue),
            ),
            // autofocus: true,
            style: TextStyle(fontSize: 20, color: Colors.teal),
          ),
        ),
        if (isLoading)
          SizedBox(
            height: _deviceSize.height / 6.5,
          ),
        if (isLoading)
          SpinKitFadingCircle(
            color: Colors.orange,
          ),
      ]),
      backgroundColor: Colors.transparent,
    );
  }
}
