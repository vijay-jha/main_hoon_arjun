import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/constants.dart';
import 'package:main_hoon_arjun/screens/favorites_screen.dart';
import 'package:main_hoon_arjun/screens/feed_screen.dart';
import 'package:main_hoon_arjun/screens/geeta_read_screen.dart';
import 'package:main_hoon_arjun/screens/homepage_screen.dart';
import 'package:main_hoon_arjun/screens/settings_screen.dart';

class NavigationFile extends StatefulWidget {
  static const routeName = '/navigation-file';
  @override
  _NavigationFileState createState() => _NavigationFileState();
}

class _NavigationFileState extends State<NavigationFile> {
  int _selectedIndex = 2;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //different pages to navigate to
  final List<Widget> _children = [
    GeetaReadScreen(),
    FavoritesScreen(),
    HomepageScreen(),
    FeedScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryTextC,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Read Geeta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
