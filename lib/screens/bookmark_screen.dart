import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/bookmark.dart';
import 'package:main_hoon_arjun/widgets/bookmark_card.dart';
import 'package:main_hoon_arjun/widgets/noItemInList.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const BookmarkScreen() : super();

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => BookmarkShlok(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.orange, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10),
                  child: Text(
                    "Bookmarks",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Bookmark')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder: (context, streamSnapShot) {
              if (streamSnapShot.connectionState == ConnectionState.waiting) {
                return NoItemInList.loading(_deviceSize,true);
              }
              if (streamSnapShot.hasData) {
              
                return FutureBuilder(
                    future: Provider.of<BookmarkShlok>(context, listen: false)
                        .fetchBookmarkShlok(streamSnapShot.data),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? NoItemInList.loading(_deviceSize,true)
                          : Provider.of<BookmarkShlok>(context, listen: false)
                                  .shlok()
                                  .isEmpty
                              ? NoItemInList.noShloks(_deviceSize,true)
                              : BookmarkList(Provider.of<BookmarkShlok>(context,
                                      listen: false)
                                  .shlok());
                    });
              }
              return NoItemInList.noShloks(_deviceSize,true);
            }),
      ),
    );
  }
}

class BookmarkList extends StatelessWidget {
  BookmarkList(this.shlok);
  List<Map<String, dynamic>> shlok;
  @override
  Widget build(BuildContext context) {
    shlok = [...shlok.reversed];
    return ListView.builder(
        itemCount: shlok.length,
        itemBuilder: (BuildContext context, int index) {
          return BookmarkCard(shlok[index]);
        });
  }
}
