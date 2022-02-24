import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoItemInList {
  static Widget loading(var _deviceSize, bool isBookmark) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          top: isBookmark
              ? 0
              : _deviceSize.height * 0.27),
      child: const LoadingSpinner(),
    );
  }

  static Widget noShloks(var _deviceSize, bool isBookmark) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top:isBookmark?_deviceSize.height * 0.2: _deviceSize.height * 0.12,
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

class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner();

  @override
  _LoadingSpinnerState createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.33),
      padding: const EdgeInsets.symmetric(horizontal: 80),
      // decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Lottie.asset(
        'assets/lottie/loading_orange.json',
        height: MediaQuery.of(context).size.height * 0.10,
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
