import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import './introduction_screen.dart';
import '../navigationFile.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.isLogin});
  final isLogin;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: (5)),
      vsync: this,
    );
  }

  String shlok =
      "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥";
  String welcome = "नमस्ते";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // backgroundColor: Color.fromRGBO(227, 52, 47, 255),
      // backgroundColor: const Color(0xFFe3342f),
      body: Column(
        children: [
          Lottie.asset(
            'assets/lottie/shri_ram_new.json', //change the path here
            controller: _controller,
            height: MediaQuery.of(context).size.height * 1,
            animate: true,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().whenComplete(
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.isLogin
                          ? NavigationFile()
                          : IntroductionScreens(),
                    ), //change the navigation here
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider_architecture/provider_architecture.dart';

// class StartupView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelProvider<StartupViewModel>.withConsumer(
//       viewModel: StartupViewModel(),
//       builder: (context, model, child) => Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               SizedBox(
//                 width: 300,
//                 height: 100,
//                 child: Image.asset("assets/images/intro.png"),
//               ),
//               const CircularProgressIndicator(
//                 strokeWidth: 3,
//                 valueColor: AlwaysStoppedAnimation(Color(0xff19c71)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
