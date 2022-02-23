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

        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index){
           return BookmarkCard();
        }),  
    );
  }
}
