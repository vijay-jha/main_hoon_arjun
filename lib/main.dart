import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/widgets/custom_page_transition.dart';
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

void main() => runApp(MyApp());

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
        home: HomepageScreen(),
        onGenerateRoute: (route) => onGenerateRoute(route),
      ),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomepageScreen.routeName:
        return CustomPageTransition(child: HomepageScreen());
      case SettingsScreen.routeName:
        return CustomPageTransition(child: SettingsScreen());
      case AboutScreen.routeName:
        return CustomPageTransition(child: AboutScreen());
      case SignOutSplashScreen.routeName:
        return CustomPageTransition(child: SignOutSplashScreen());
      case DisplayAvatar.routeName:
        return CustomPageTransition(child: DisplayAvatar());
      case GeetaReadScreen.routeName:
        return CustomPageTransition(child: GeetaReadScreen());
      case FavoritesScreen.routeName:
        return CustomPageTransition(child: FavoritesScreen());
      default:
        return CustomPageTransition(child: HomepageScreen());
    }
  }
}
