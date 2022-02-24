import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/widgets/bookmark_card.dart';


class BookmarkScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const BookmarkScreen() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.orange, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10),
                child: Text(
                  "Bookmarks",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold),
                )),
          ])),

        // body: StreamBuilder(
        // stream: FirebaseFirestore.instance
        //     .collection('user_favorites')
        //     .doc(FirebaseAuth.instance.currentUser.uid)
        //     .snapshots(),
        // builder: (context, streamSnapShot) {
        //   if (streamSnapShot.connectionState == ConnectionState.waiting) {
        //     return loading(_deviceSize);
        //   }
        //   if (streamSnapShot.hasData) {
        //     return FutureBuilder(
        //         future: Provider.of<FavoritesShlok>(context, listen: false)
        //             .fetchFavoriteShlok(streamSnapShot.data),
        //         builder: (context, snapshot) {
        //           return snapshot.connectionState == ConnectionState.waiting
        //               ? loading(_deviceSize)
        //               : Provider.of<FavoritesShlok>(context, listen: false)
        //                       .shlok()
        //                       .isEmpty
        //                   ? noFavorites(_deviceSize)
        //                   : ListView.builder(
        //   itemCount: 10,
        //   itemBuilder: (BuildContext context, int index){
        //    return BookmarkCard();
        // });
        //         });
        //   }
        //   return noFavorites(_deviceSize);
        // });
    );
  }
}

