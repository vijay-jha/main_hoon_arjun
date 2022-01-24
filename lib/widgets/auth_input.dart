// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './input_container.dart';
import '../constants.dart';

enum Password { visibility, nonVisibility }

class RoundedInput extends StatefulWidget {
  const RoundedInput({
    Key key,
    @required this.iconColor,
    @required this.textColor,
    @required this.submit,
    @required this.isLogin,
  }) : super(key: key);

  final Color iconColor;
  final Color textColor;
  final Function submit;
  final bool isLogin;

  @override
  State<RoundedInput> createState() => _RoundedInputState();
}

class _RoundedInputState extends State<RoundedInput>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _usernameController = TextEditingController();
  Password _password = Password.nonVisibility;
  bool isLoading = false;
  String errorMessage = "";

  Future<void> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    }
    // ignore: empty_catches
    on TickerCanceled {}
  }

  @override
  void initState() {
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // if (!widget.isLogin)
        // InputContainer(
        //   child: TextField(
        //     controller: _usernameController,
        //     cursorColor: primaryTextC,
        //     keyboardType: TextInputType.emailAddress,
        //     decoration: InputDecoration(
        //       icon: Icon(
        //         Icons.person,
        //         color: widget.iconColor,
        //       ),
        //       hintText: "Name",
        //       hintStyle: TextStyle(color: widget.textColor),
        //       border: InputBorder.none,
        //     ),
        //     style: TextStyle(color: widget.textColor),
        //   ),
        // ),
        InputContainer(
          child: TextField(
            controller: _emailController,
            cursorColor: primaryTextC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.email,
                color: widget.iconColor,
              ),
              hintText: "Email",
              hintStyle: TextStyle(color: widget.textColor),
              border: InputBorder.none,
              suffixIcon: _emailController.text.isNotEmpty
                  ? InkWell(
                      child: Icon(Icons.clear_rounded),
                      onTap: () {
                        setState(() {
                          _emailController.text = "";
                        });
                      },
                    )
                  : null,
            ),
            style: TextStyle(color: widget.textColor),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        InputContainer(
          child: TextField(
            controller: _passwordController,
            cursorColor: widget.textColor,
            obscureText: _password == Password.nonVisibility ? true : false,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: widget.iconColor,
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: widget.textColor),
              border: InputBorder.none,
              suffixIcon: InkWell(
                child: Icon(
                  _password == Password.nonVisibility
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onTap: () {
                  if (_password == Password.nonVisibility) {
                    setState(() {
                      _password = Password.visibility;
                    });
                  } else {
                    setState(() {
                      _password = Password.nonVisibility;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        if (widget.isLogin)
          Container(
            margin: EdgeInsets.only(right: 40),
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final _user = FirebaseAuth.instance;
                if (_emailController.text.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Reset Your Password"),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                      content: Text("We will send you an email."),
                      actions: [
                        OutlinedButton(
                            onPressed: () async {
                              await Future.delayed(Duration(milliseconds: 200));
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
                        OutlinedButton(
                          onPressed: () async {
                            await Future.delayed(Duration(milliseconds: 200));
                            try {
                              await _user.sendPasswordResetEmail(
                                email: _emailController.text,
                              );
                            } on FirebaseAuthException catch (error) {
                            switch (error.code) {
                                case "user-not-found":
                                  errorMessage =
                                      "User with this email doesn't exist.";  
                                  break;
                                case "invalid-email":   
                                errorMessage =
                                      "Please enter a valid email address."; 
                                  break;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text("Okay"),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Enter an Email address."),
                      backgroundColor: Theme.of(context).errorColor,
                    ),
                  );
                }
              },
              child: Text("Forgot Password?"),
            ),
          ),
        SizedBox(
          height: widget.isLogin ? 10 : 20,
        ),
        InkWell(
          onTap: () async {
            _playAnimation();
            FocusScope.of(context).unfocus();
            if (isLoading) return;
            if (_emailController.text != "" && _passwordController.text != "") {
              setState(() {
                isLoading = true;
              });
            }
            widget.submit(
              context,
              _emailController.text,
              _passwordController.text,
              widget.isLogin,
            );
            await Future.delayed(Duration(milliseconds: 2000)); 
            setState(() {
              isLoading = false;
            });
          },
          child: Container(
            width: size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kPrimaryC,
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    widget.isLogin ? "LOGIN" : "SIGN UP",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
          ),
        )
      ],
    );
  }
}
