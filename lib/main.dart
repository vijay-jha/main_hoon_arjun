import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_hoon_arjun/widgets/speaker_icon_button.dart';
import 'package:provider/provider.dart';

import './providers/mahabharat_characters.dart';
import './widgets/custom_page_transition.dart';
import './navigationFile.dart';
import './screens/auth_screen.dart';
import './screens/desired_shlok_screen.dart';
import './screens/intro_splash_screen.dart';
import './screens/settings_screen.dart';
import './screens/about_screen.dart';
import './screens/homepage_screen.dart';
import './screens/signout_splash_screen.dart';
import './screens/choose_avatar_screen.dart';
import './screens/geeta_read_screen.dart';
import './screens/favorites_screen.dart';
import './screens/feed_screen.dart';
import './screens/comment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  WidgetsBinding.instance.addObserver(new _Handler());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MahabharatCharacters(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
          ),
        ),
        // home: SplashScreen(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.hasData) {
              return SplashScreen(
                isLogin: true,
              );
            }
            return SplashScreen(
              isLogin: false,
            );
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
    }
  }
}

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SpeakerIcnBtn.player
          .resume(); // Audio player is a custom class with resume and pause static methods
    } else {
      SpeakerIcnBtn.player.pause();
    }
  }
}
