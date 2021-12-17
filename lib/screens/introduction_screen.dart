import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import 'auth_screen.dart';

class IntroductionScreens extends StatelessWidget {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Lottie.asset("assets/lottie/reading_a_book.json"),
        title: "Get ready to read Geeta in a new Experience",
        body: "",
        footer: const Text(""),
      ),
      PageViewModel(
        image: Lottie.asset("assets/lottie/book_reading.json"),
        title: "Read and Understand the meaning",
        body: "",
        footer: const Text(""),
      ),
      PageViewModel(
        image: Lottie.asset("assets/lottie/mobile_tap.json"),
        title: "Complete Geeta\nOn Your Own Mobile",
        body: "",
        footer: const Text("Click on Done to Begin"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        done: const Text(
          'Done',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        onDone: () {
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
        },
        pages: getPages(),
        globalBackgroundColor: Colors.white,
        showDoneButton: true,
        showSkipButton: true,
        showNextButton: true,
        next: const Text("Next"),
        skip: const Text("Skip"),
      ),
    );
  }
}
