import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_hoon_arjun/navigationFile.dart';

import 'verify_screen.dart';
import '../widgets/text_field.dart';

enum AuthMode { Signup, Login }
enum Password { visibility, nonVisibility }

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
  static const routeName = '/auth-screen';
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = 'Please enter your credentials.';
  Timer timer;

  AuthMode _authMode = AuthMode.Login;
  Password _password = Password.nonVisibility;

  void _submitAuthForm(BuildContext ctx) async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      UserCredential authResult;
      try {
        if (_authMode == AuthMode.Login) {
          authResult = await _auth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        } else {
          authResult = await _auth
              .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          )
              .then(
            (_) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => VerifyScreen(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                ),
              );

              return null;
            },
          );
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "weak-password":
            errorMessage = "Please enter a strong password.";
            break;
          case "invalid-email":
            errorMessage = "Please enter a valid email address.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests. Try again later.";
            break;
        }
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(''),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: _deviceSize.height * 0.35,
            width: _deviceSize.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(
                horizontal: _deviceSize.width * 0.1, vertical: 30),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              child: ListView(
                children: [
                  TextFieldContainer(
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                        ),
                        hintText: "Your Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextField(
                      controller: _passwordController,
                      obscureText:
                          _password == Password.nonVisibility ? true : false,
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(
                          Icons.lock,
                        ),
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
                  SizedBox(height: 20),
                  Align(
                    child: SizedBox(
                      width: _authMode == AuthMode.Login
                          ? _deviceSize.width * 0.2
                          : _deviceSize.width * 0.25,
                      child: ElevatedButton(
                        child: Text(
                            _authMode == AuthMode.Login ? 'Login' : 'Sign up'),
                        onPressed: () {
                          _submitAuthForm(context);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _authMode == AuthMode.Login
                    ? "Don't have an account?"
                    : "Already have an account?",
              ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(_authMode == AuthMode.Login ? 'Sign up' : 'Login'),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(NavigationFile.routeName);
          },
          label: Text("Skip"),
        ),
      ),
    );
  }
}
