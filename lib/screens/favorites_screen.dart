import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/noItemInList.dart';
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
  @override
  void dispose() {
    super.dispose();
    SpeakerIcnBtn.player.dispose();
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
            return SliverToBoxAdapter(
                child: NoItemInList.loading(_deviceSize, false));
          }
          if (streamSnapShot.hasData) {
            return FutureBuilder(
                future: Provider.of<FavoritesShlok>(context, listen: false)
                    .fetchFavoriteShlok(streamSnapShot.data),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? SliverToBoxAdapter(
                          child: NoItemInList.loading(_deviceSize, false))
                      : Provider.of<FavoritesShlok>(context, listen: false)
                              .shlok()
                              .isEmpty
                          ? SliverToBoxAdapter(
                              child: NoItemInList.noShloks(_deviceSize, false))
                          : FavoritesItemList(
                              shlok: Provider.of<FavoritesShlok>(context,
                                      listen: false)
                                  .shlok());
                },
                );
          }
          return SliverToBoxAdapter(
              child: NoItemInList.noShloks(_deviceSize, false));
        });
  }
}

class FavoritesItemList extends StatefulWidget {
  FavoritesItemList({
    @required this.shlok,
  });

  List<Map<String, dynamic>> shlok;

  @override
  State<FavoritesItemList> createState() => _FavoritesItemListState();
}

class _FavoritesItemListState extends State<FavoritesItemList> {
  @override
  Widget build(BuildContext context) {
    widget.shlok = [...widget.shlok.reversed];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FavoriteShlokItem(widget.shlok[index], index),
        childCount: widget.shlok.length,
      ),
    );
  }
}
