import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/favorite_shlok.dart';
import '../widgets/speaker_icon_button.dart';
import '../providers/playing_shlok.dart';
import '../providers/favorite.dart';

class FavoritesScreen extends StatefulWidget {
  static const String routeName = "/favorites-screen";

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PlayingShlok(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Container(
          color: Colors.orange.shade50,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.orange.shade600,
                expandedHeight: 240,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  // centerTitle: true,
                  title: const Text(
                    "Favorites",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  background: Image.asset(
                    "assets/images/shrikrushnaArjun.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const FavoritesBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesBody extends StatefulWidget {
  const FavoritesBody();

  @override
  _FavoritesBodyState createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<FavoritesBody> {
  Widget loading(var _deviceSize) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: _deviceSize.height * 0.30),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget noFavorites(var _deviceSize) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: _deviceSize.height * 0.30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              " No Favorite Shlok",
              textAlign: TextAlign.center,
            ),
            Text(
              " Add Some!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_favorites')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, streamSnapShot) {
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return loading(_deviceSize);
          }
          if (streamSnapShot.hasData) {
            return FutureBuilder(
                future: Provider.of<FavoritesShlok>(context, listen: false)
                    .fetchFavoriteShlok(streamSnapShot.data),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? loading(_deviceSize)
                      : Provider.of<FavoritesShlok>(context, listen: false)
                              .shlok()
                              .isEmpty
                          ? noFavorites(_deviceSize)
                          : FavoritesItemList(
                              shlok: Provider.of<FavoritesShlok>(context,
                                      listen: false)
                                  .shlok());
                });
          }
          return noFavorites(_deviceSize);
        });
  }
}

class FavoritesItemList extends StatefulWidget {
  const FavoritesItemList({
    Key key,
    @required this.shlok,
  }) : super(key: key);

  final List<Map<String, dynamic>> shlok;

  @override
  State<FavoritesItemList> createState() => _FavoritesItemListState();
}

class _FavoritesItemListState extends State<FavoritesItemList> {
  @override
  void dispose() {
    super.dispose();
    SpeakerIcnBtn.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FavoriteShlokItem(widget.shlok[index], index),
        childCount: widget.shlok.length,
      ),
    );
  }
}
