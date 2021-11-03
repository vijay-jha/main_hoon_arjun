import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/mahabharat_characters.dart';
import './screens/desired_shlok_screen.dart';
import './screens/settings_screen.dart';
import './screens/about_screen.dart';
import './screens/language_preference_screen.dart';
import './screens/homepage_screen.dart';
import './screens/signout_splash_screen.dart';
import './screens/choose_avatar_screen.dart';
import './screens/geeta_read_screen.dart';
import './screens/favorites_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => MahabharatCharacters(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.white,
            ),
          ),
          home: HomepageScreen(),
          // home: HomepageScreen(),
          routes: {
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            AboutScreen.routeName: (ctx) => AboutScreen(),
            DesiredShlokScreen.routeName: (ctx) => DesiredShlokScreen(),
            LanguagePreferenceScreen.routeName: (ctx) => LanguagePreferenceScreen(),
            SignOutSplashScreen.routeName: (ctx) => SignOutSplashScreen(),
            DisplayAvatar.routeName: (ctx) =>  DisplayAvatar(),
            GeetaReadScreen.routeName: (ctx) => GeetaReadScreen(),
            FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
          }),
    );
  }
}
