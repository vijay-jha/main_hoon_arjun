// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/widgets/profile_picture.dart';

class CommentBox extends StatelessWidget {
  Widget child;
  dynamic formKey;
  dynamic sendButtonMethod;
  dynamic commentController;
  String userImage;
  String labelText;
  String errorText;
  Widget sendWidget;
  Color backgroundColor;
  Color textColor;
  bool withBorder;
  Widget header;
  FocusNode focusNode;

  CommentBox({
    this.child,
    this.header,
    this.sendButtonMethod,
    this.formKey,
    this.commentController,
    this.sendWidget,
    this.userImage,
    this.labelText,
    this.focusNode,
    this.errorText,
    this.withBorder = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(child: child),
        header ?? SizedBox.shrink(),
        ListTile(
          tileColor: backgroundColor,
          leading: Container(
            height: _deviceSize.height * 0.05, // 40
            child: ProfilePicture(),
          ),
          title: Form(
            key: formKey,
            child: TextFormField(
              maxLines: 4,
              minLines: 1,
              focusNode: focusNode,
              cursorColor: textColor,
              style: TextStyle(color: textColor),
              controller: commentController,
              decoration: InputDecoration(
                enabledBorder: !withBorder
                    ? InputBorder.none
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                focusedBorder: !withBorder
                    ? InputBorder.none
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                border: !withBorder
                    ? InputBorder.none
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                labelText: labelText,
                focusColor: textColor,
                fillColor: textColor,
                labelStyle: TextStyle(color: textColor),
              ),
              validator: (value) => value.isEmpty ? errorText : null,
            ),
          ),
          trailing: GestureDetector(
            onTap: sendButtonMethod,
            child: sendWidget,
          ),
        ),
      ],
    );
  }
}
