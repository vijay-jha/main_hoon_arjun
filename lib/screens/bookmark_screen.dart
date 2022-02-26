import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/bookmark.dart';
import 'package:main_hoon_arjun/widgets/bookmark_card.dart';
import 'package:main_hoon_arjun/widgets/noItemInList.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen();

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => BookmarkShlok(),
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
                    "Bookmark",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  background: Image.asset(
                    "assets/images/MorPankh.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const BookmarkBody(),
            ],
          ),
        ),
      ),
    );
  }
}


class BookmarkBody extends StatefulWidget {
  const BookmarkBody();

  @override
  _BookmarkBobyState createState() => _BookmarkBobyState();
}

class _BookmarkBobyState extends State<BookmarkBody> {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Bookmark')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, streamSnapShot) {
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return NoItemInList.loading(_deviceSize);
          }
          if (streamSnapShot.hasData) {
            return FutureBuilder(
                future: Provider.of<BookmarkShlok>(context, listen: false)
                    .fetchBookmarkShlok(streamSnapShot.data),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? NoItemInList.loading(_deviceSize)
                      : Provider.of<BookmarkShlok>(context, listen: false)
                              .shlok()
                              .isEmpty
                          ? NoItemInList.noShloks(_deviceSize)
                          : BookmarkList(
                              Provider.of<BookmarkShlok>(context, listen: false)
                                  .shlok());
                });
          }
          return NoItemInList.noShloks(_deviceSize);
        });
  }
}

class BookmarkList extends StatelessWidget {
  BookmarkList(this.shlok);
  List<Map<String, dynamic>> shlok;
  @override
  Widget build(BuildContext context) {
    shlok = [...shlok.reversed];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => BookmarkCard(shlok[index]),
        childCount: shlok.length,
      ),
    );
  }
}
