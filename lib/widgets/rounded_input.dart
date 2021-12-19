// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../constants.dart';
import './input_container.dart';

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

class _RoundedInputState extends State<RoundedInput> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  Password _password = Password.nonVisibility;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        if (!widget.isLogin)
          InputContainer(
            child: TextField(
              controller: _nameController,
              cursorColor: primaryTextC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: widget.iconColor,
                ),
                hintText: "Name",
                hintStyle: TextStyle(color: widget.textColor),
                border: InputBorder.none,
              ),
              style: TextStyle(color: widget.textColor),
            ),
          ),
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
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            widget.submit(
              context,
              _emailController.text,
              _passwordController.text,
              widget.isLogin,
            );
          },
          child: Container(
            width: size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kPrimaryC,
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text(
              widget.isLogin ? "LOGIN" : "SIGN UP",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
      ],
    );
  }
}
