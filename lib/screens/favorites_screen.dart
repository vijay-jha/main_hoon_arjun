import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/favorite_shlok.dart';
import '../widgets/speaker_icon_button.dart';
import '../providers/playing_shlok.dart';

class FavoritesScreen extends StatefulWidget {
  static const String routeName = "/favorites-screen";

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
//   List<Map<String, dynamic>> shlok = [
//     {
//       "Shlok": """
// क्लैब्यं मा स्म गमः पार्थ नैतत्त्वय्युपपद्यते।
// क्षुद्रं हृदयदौर्बल्यं त्यक्त्वोत्तिष्ठ परन्तप।।
//                       """,
//       "Audio": "",
//       "Number": "अ.१, श्लोक.१",
//       "Chapter": "Chapter02",
//       "hlok": "Shlok03",
//     },
//   ];

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PlayingShlok(),
        )
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
  List<Map<String, dynamic>> shlok = [];
  var data1;
  bool isLoading = true;

  Future<void> fetchUserFavorites() async {
    final _user = FirebaseAuth.instance.currentUser;

    var userFavorite = await FirebaseFirestore.instance
        .collection('user_favorites')
        .doc(_user.uid)
        .get();

    if (userFavorite.exists) {
      var data = userFavorite.data();
      var favoriteShloks = data['fav_sholks'];

      for (int i = 0; i < favoriteShloks.length; i++) {
        var favorite = favoriteShloks[i];
        var chapterAndShlok = favorite.split('_');
        var allShloksFromChapter = await FirebaseFirestore.instance
            .collection('Geeta')
            .doc(chapterAndShlok[0])
            .get();

        print('-----------------------');
        var data = allShloksFromChapter.data();
        data1 = data['Shlok01']['meaning']['hindi'];
        print('-----------------------');
        var particularShlok = allShloksFromChapter[chapterAndShlok[1]];

        shlok.add({
          "Shlok": particularShlok['text'],
          "Number":
              "अ.${chapterAndShlok[0].substring(7)}, श्लोक.${chapterAndShlok[1].substring(5)}",
          "Chapter": chapterAndShlok[0],
          "ShlokNo": chapterAndShlok[1],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: fetchUserFavorites(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: _deviceSize.height * 0.30),
                    child: const CircularProgressIndicator(),
                  ),
                )
              : shlok.isEmpty
                  ? SliverToBoxAdapter(
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
                    )
                  : FavoritesItemList(shlok: shlok);
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
