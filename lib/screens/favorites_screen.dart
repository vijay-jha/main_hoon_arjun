import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  @override
  void dispose() {
    super.dispose();
    SpeakerIcnBtn.player.stop();
  }
  
  Widget loading(var _deviceSize) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: _deviceSize.height * 0.27),
        child: const LoadingSpinner(),
      ),
    );
  }

  Widget noFavorites(var _deviceSize) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: _deviceSize.height * 0.12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            EmptyList(),
            Text(
              " Add Some !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.w700,
              ),
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
  FavoritesItemList({
    Key key,
    @required this.shlok,
  }) : super(key: key);

  List<Map<String, dynamic>> shlok;

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
    widget.shlok = [...widget.shlok.reversed];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FavoriteShlokItem(widget.shlok[index], index),
        childCount: widget.shlok.length,
      ),
    );
  }
}

class EmptyList extends StatefulWidget {
  const EmptyList();

  @override
  _EmptyListState createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Lottie.asset(
        'assets/lottie/empty_list.json',
        height: MediaQuery.of(context).size.height * 0.30,
        controller: _controller,
        animate: true,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }
}

class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner();

  @override
  _LoadingSpinnerState createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.33),
      padding: const EdgeInsets.symmetric(horizontal: 80),
      // decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Lottie.asset(
        'assets/lottie/loading_orange.json',
        height: MediaQuery.of(context).size.height * 0.10,
        controller: _controller,
        animate: true,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }
}
