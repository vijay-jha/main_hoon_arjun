import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class NoItemInList {
  static Widget loading(var _deviceSize) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: _deviceSize.height * 0.27),
        child: SpinKitFadingCircle(color: Colors.orange),
      ),
    );
  }

  static Widget noShloks(var _deviceSize) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: _deviceSize.height * 0.12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            EmptyList(),
            Text(
              " Add Some !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyList extends StatefulWidget {
  const EmptyList();

  @override
  _EmptyListState createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Lottie.asset(
        'assets/lottie/empty_list.json',
        height: MediaQuery.of(context).size.height * 0.30,
        controller: _controller,
        animate: true,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }
}
