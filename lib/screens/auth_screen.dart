// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './login_splash_screen.dart';
import './verify_screen.dart';
import '../constants.dart';
import '../widgets/auth_input.dart';
import '../providers/mahabharat_characters.dart';

enum Password { visibility, nonVisibility }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  String errorMessage = 'Please enter your credentials.';
  Timer timer;

@override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _submitAuthForm(BuildContext ctx, email, password, isLogin) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      UserCredential authResult;
      try {
        if (isLogin) {
          authResult = await _auth
              .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
              .then((_) async {
            final _user = FirebaseAuth.instance.currentUser;
            if (_user.emailVerified) {
              var doc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(_user.uid)
                  .get();
              if (!doc.exists) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_user.uid)
                    .set({
                  'email': email,
                  'username': 'Arjun',
                  'avatarIndex': 0,
                });
              }
              Provider.of<MahabharatCharacters>(context, listen: false)
                  .saveAvatarTolocal();

              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => LoginSplash(),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.orange.shade50,
                  content: Text("Please verify the email."),
                  actions: [
                    OutlinedButton(
                      onPressed: () async {
                        await Future.delayed(Duration(milliseconds: 200));
                        _user.sendEmailVerification();
                        Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName);
                      },
                      child: Text("Okay"),
                    ),
                  ],
                ),
              );
            }
            return null;
          });
        } else {
          await  _auth
              .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
              .then(
            (_) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => VerifyScreen(
                    email: email,
                  ),
                ),
              );
              return null;
            },
          );
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "email-already-in-use":
            errorMessage = "Already have an account. Try Login";
            break;
          case "weak-password":
            errorMessage = "Please enter a strong password.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "invalid-email":
            errorMessage = "Please enter a valid email address..............";
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
            content: Text(errorMessage),
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

  bool isLogin = true;
  Animation<double> containerSize;
  AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);

  

  @override
  Widget build(BuildContext context) {
    Size _deviceSize = MediaQuery.of(context).size;
    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; //using this to determine whether keyboard is opened or not
    double defaultLoginSize = _deviceSize.height - (_deviceSize.height * 0.2);
    double defaultRegisterSize =
        _deviceSize.height - (_deviceSize.height * 0.1);

    containerSize = Tween<double>(
            begin: _deviceSize.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
              top: _deviceSize.height * 0.14,
              right: -50,
              child: Container(
                width: _deviceSize.width * 0.28,
                height: _deviceSize.height * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kPrimaryC,
                ),
              )),

          //left
          Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: _deviceSize.width * 0.5,
                height: _deviceSize.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kPrimaryC,
                ),
              )),

          //cancel button
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _deviceSize.width,
                height: _deviceSize.height * 0.1,
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: isLogin
                      ? null
                      : () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            animationController.reverse();
                            isLogin = !isLogin;
                          });
                        },
                  icon: Icon(Icons.close),
                ),
              ),
            ),
          ),

          // Login form
          AnimatedOpacity(
            opacity: isLogin ? 1.0 : 0.0,
            duration: animationDuration * 4,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: _deviceSize.width,
                  height: defaultLoginSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Book.png",
                        width: _deviceSize.width * 0.55,
                        height: _deviceSize.height * 0.2,
                      ),
                      SizedBox(
                        height: _deviceSize.height * 0.08,
                      ),
                      RoundedInput(
                        iconColor: kPrimaryC,
                        submit: _submitAuthForm,
                        isLogin: true,
                        textColor: Colors.orange.shade900,
                        deviceSize: _deviceSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Register Container & Keyboard Controller
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }
              //returning empty container to hide this widget
              return Container();
            },
          ),

          //SignUp Form
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration * 5,
            child: Visibility(
              visible: !isLogin,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    width: _deviceSize.width,
                    height: defaultLoginSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: _deviceSize.height * 0.015,
                        ),
                        Image.asset(
                          "assets/images/Book.png",
                          width: _deviceSize.width * 0.55,
                          height: _deviceSize.height * 0.2,
                        ),
                        SizedBox(
                          height: _deviceSize.height * 0.06,
                        ),
                        RoundedInput(
                          iconColor: secondaryC,
                          submit: _submitAuthForm,
                          isLogin: false,
                          textColor: secondaryC,
                          deviceSize: _deviceSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: !isLogin
            ? null
            : () {
                animationController.forward();
                setState(() {
                  isLogin = !isLogin;
                });
              },
        child: Container(
          width: double.infinity,
          height: containerSize.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: kBackgroundC,
          ),
          alignment: Alignment.center,
          child: isLogin
              ? Text(
                  "Don't have an account ? Sign Up",
                  style: TextStyle(color: secondaryC, fontSize: 18),
                )
              : null,
        ),
      ),
    );
  }
}
