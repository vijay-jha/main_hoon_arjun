import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:main_hoon_arjun/providers/favorite.dart';
import 'package:main_hoon_arjun/providers/playing_shlok.dart';
import 'package:main_hoon_arjun/widgets/speaker_icon_button.dart';
import 'package:provider/provider.dart';

import './providers/mahabharat_characters.dart';
import './widgets/custom_page_transition.dart';
import 'navigation_file.dart';
import './screens/auth_screen.dart';
import './screens/desired_shlok_screen.dart';
import './screens/settings_screen.dart';
import './screens/about_screen.dart';
import './screens/homepage_screen.dart';
import './screens/signout_splash_screen.dart';
import './screens/choose_avatar_screen.dart';
import './screens/geeta_read_screen.dart';
import './screens/favorites_screen.dart';
import './screens/feed_screen.dart';
import './screens/comment_screen.dart';
import './screens/introduction_screen.dart';
import './screens/one_time_intro_screen.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container(
        child: AlertDialog(
          backgroundColor: Colors.orange.shade50,
          content: Text("Sorry for inconvienience!! Please Restart."),
          actions: [
            OutlinedButton(
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 200));
                FlutterRestart.restartApp();
              },
              child: Text("Restart"),
            ),
          ],
        ),
      );
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  runApp(MyApp());
  WidgetsBinding.instance.addObserver(_Handler());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MahabharatCharacters(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FavoritesShlok(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PlayingShlok(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Hind',
          primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapShot) {
              if (userSnapShot.hasData) {
              final _user = FirebaseAuth.instance.currentUser;
              if (_user.emailVerified) {
                return NavigationFile();
              }
            }
            return OneTimeIntro();
          },
        ),
        onGenerateRoute: (route) => onGenerateRoute(route),
      ),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case HomepageScreen.routeName:
        return CustomPageTransition(child: HomepageScreen());
      case SettingsScreen.routeName:
        return CustomPageTransition(child: SettingsScreen());
      case AboutScreen.routeName:
        return CustomPageTransition(child: AboutScreen());
      case SignOutSplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => SignOutSplashScreen());
      case DisplayAvatar.routeName:
        return CustomPageTransition(child: DisplayAvatar());
      case GeetaReadScreen.routeName:
        return CustomPageTransition(child: GeetaReadScreen());
      case FavoritesScreen.routeName:
        return CustomPageTransition(child: FavoritesScreen());
      case FeedScreen.routeName:
        return CustomPageTransition(child: FeedScreen());
      case CommentScreen.routeName:
        return CustomPageTransition(child: CommentScreen());
      case NavigationFile.routeName:
        return CustomPageTransition(child: NavigationFile());
      case DesiredShlokScreen.routeName:
        return CustomPageTransition(child: DesiredShlokScreen());
      case IntroductionScreens.routeName:
        return MaterialPageRoute(builder: (_) => IntroductionScreens());
    }
  }
}

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (SpeakerIcnBtn.player != null) {
      if (state == AppLifecycleState.resumed) {
        SpeakerIcnBtn.player
            .play(); // Audio player is a custom class with resume and pause static methods
      } else {
        SpeakerIcnBtn.player.pause();
      }
    }
  }
}
