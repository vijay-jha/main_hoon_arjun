// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './screens/favorites_screen.dart';
import './screens/bookmark_screen.dart';
// import './screens/feed_screen.dart';
import './screens/geeta_read_screen.dart';
import './screens/homepage_screen.dart';
import './screens/settings_screen.dart';
import './providers/mahabharat_characters.dart';

class NavigationFile extends StatefulWidget {
  static const routeName = '/navigation-file';

  @override
  _NavigationFileState createState() => _NavigationFileState();
}

class _NavigationFileState extends State<NavigationFile> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();

    Provider.of<MahabharatCharacters>(context, listen: false)
        .getIndexFromLocal();
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Different pages to navigate to
  final List<Widget> _children = [
    GeetaReadScreen(),
    BookmarkScreen(),
    HomepageScreen(),
    // FeedScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange.shade100,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Geeta',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border_outlined),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite_rounded),
            icon: Icon(Icons.favorite_border_rounded),
            label: 'Favorite',
          ),
          // BottomNavigationBarItem(
          //   activeIcon: Icon(Icons.feed_rounded),
          //   backgroundColor: Colors.red,
          //   icon: Icon(Icons.feed_outlined),
          //   label: 'Feed',
          // ),

          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings_rounded),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
