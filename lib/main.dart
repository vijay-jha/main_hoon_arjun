import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/navigationFile.dart';
import 'package:main_hoon_arjun/screens/splash_screen.dart';
import 'package:main_hoon_arjun/widgets/custom_page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './providers/playing_shlok.dart';
import './providers/mahabharat_characters.dart';
import './screens/settings_screen.dart';
import './screens/about_screen.dart';
import './screens/homepage_screen.dart';
import './screens/signout_splash_screen.dart';
import './screens/choose_avatar_screen.dart';
import './screens/geeta_read_screen.dart';
import './screens/favorites_screen.dart';
import './screens/auth_screen.dart';
import './screens/feed_screen.dart';
import './screens/comment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
          create: (ctx) => PlayingShlok(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
          ),
        ),
        home: SplashScreen(),
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
    }
  }
}
