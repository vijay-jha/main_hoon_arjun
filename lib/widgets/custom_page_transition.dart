
import 'package:flutter/material.dart';

class CustomPageTransition extends PageRouteBuilder {
  final Widget child;

  CustomPageTransition({
    @required this.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // From right to left
          end: const Offset(0, 0),
        ).animate(animation),
        child: child,
      );
}
