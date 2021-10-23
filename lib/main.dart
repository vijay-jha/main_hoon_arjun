import 'package:flutter/material.dart';

import './screens/desired_shlok_screen.dart';
import './screens/settings_screen.dart';
import './screens/about_screen.dart';
import './screens/language_preference_screen.dart';
import './screens/homepage_screen.dart';
import './screens/signout_splash_screen.dart';
import './screens/choose_avatar_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
          ),
        ),
        home: ChooseAvatarScreen(),
        // home: HomepageScreen(),
        routes: {
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          AboutScreen.routeName: (ctx) => AboutScreen(),
          DesiredShlokScreen.routeName: (ctx) => DesiredShlokScreen(),
          LanguagePreferenceScreen.routeName: (ctx) => LanguagePreferenceScreen(),
          SignOutSplashScreen.routeName: (ctx) => SignOutSplashScreen(),
          ChooseAvatarScreen.routeName: (ctx) => ChooseAvatarScreen(),
        });
  }
}
