import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/translation.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VersePage extends StatefulWidget {
  int verseNumber;
  String shlokTitle;
  final PageController pageController;
  final String shlokText;
  final Map<String, dynamic> translation;
  final Map<String, dynamic> meaning;
  final String currentShlok;
  Function checkBookmark;
  // bool isBookmark = false;

  VersePage(
      {Key key,
      @required this.verseNumber,
      this.currentShlok,
      this.pageController,
      this.shlokTitle,
      this.shlokText,
      this.translation,
      this.checkBookmark,
      this.meaning})
      : super(key: key);

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  var doc;
  bool isBookmark;

  @override
  Future<void> dispose() {
    super.dispose();
    () async {
      var doc = await FirebaseFirestore.instance
          .collection('Bookmark')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      var user = FirebaseAuth.instance.currentUser.uid;
      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('Bookmark')
            .doc(user)
            .set({'bookmarked_shloks': []});
      } else {
        var data = doc.data();
        var bookmarkedShloks = data['bookmarked_shloks'];
        if (isBookmark) {
          if (!bookmarkedShloks.contains(widget.currentShlok)) {
            bookmarkedShloks.add(widget.currentShlok);
            await FirebaseFirestore.instance
                .collection('Bookmark')
                .doc(user)
                .set({'bookmarked_shloks': bookmarkedShloks});
          }
        } else {
          bookmarkedShloks.remove((widget.currentShlok));
          await FirebaseFirestore.instance
              .collection('Bookmark')
              .doc(user)
              .set({'bookmarked_shloks': bookmarkedShloks});
        }
      }
    }();
  }

  void toggleBookmark() {
    isBookmark = !isBookmark;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //shlok number
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF37323E),
            ),
            padding: const EdgeInsets.all(11),
            child: Text(
              'Shlok ${widget.shlokTitle}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.yellow,
                fontSize: 17,
                fontFamily: 'NotoSansMono',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Bookmark')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      var docData = snapshot.data;
                      var bookmarkedShloks = docData['bookmarked_shloks'];
                      if (bookmarkedShloks.contains(widget.currentShlok)) {
                        isBookmark = true;
                      } else {
                        isBookmark = false;
                      }
                      return BookmarkButton(
                          togglebookmark: toggleBookmark,
                          isBookmark: isBookmark);
                    }
                    return Icon(Icons.bookmark_border);
                  }),
              TranslationBtn(),
            ],
          ),

          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.shlokText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          CustomWidget(title: "Meaning", content: widget.translation),
          CustomWidget(title: "Explanation", content: widget.meaning),

          //Navigation arrows
          Row(
            mainAxisAlignment: widget.verseNumber != 1
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (widget.verseNumber != 1)
                GestureDetector(
                  onTap: () {
                    int previsoupage = widget.verseNumber - 2;
                    widget.pageController.animateToPage(previsoupage,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.bounceInOut);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 40, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        //arrow
                        Icon(
                          Icons.keyboard_arrow_left_sharp,
                          color: Colors.black,
                        ),
                        Text(
                          "Prev",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  widget.pageController.animateToPage(widget.verseNumber,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.bounceInOut);
                },
                child: Container(
                    margin:
                        const EdgeInsets.only(right: 40, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        //arrow
                        Text(
                          "Next",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.keyboard_arrow_right_outlined),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookmarkButton extends StatefulWidget {
  BookmarkButton({Key key, this.togglebookmark, this.isBookmark})
      : super(key: key);

  final togglebookmark;
  bool isBookmark;

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.togglebookmark();
        setState(() {
          widget.isBookmark = !widget.isBookmark;
        });
      },
      icon: widget.isBookmark
          ? const Icon(Icons.bookmark)
          : const Icon(
              Icons.bookmark_add_outlined,
              size: 26,
            ),
      color: Colors.orange[600],
    );
  }
}

class TranslationBtn extends StatefulWidget {
  const TranslationBtn();

  @override
  _TranslationBtnState createState() => _TranslationBtnState();
}

class _TranslationBtnState extends State<TranslationBtn>
    with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<Translation>(context, listen: true).getIsEnglish();
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: Consumer<Translation>(builder: (_, tanslation, ch) {
        return IconButton(
          icon: isEnglish
              ? Image.asset('assets/images/translationEnglish.jpeg')
              : Image.asset('assets/images/tranlationHindi.jpeg'),
          onPressed: () {
            if (isEnglish) {
              Provider.of<Translation>(context, listen: false)
                  .toggleTranslation();
              _controller.forward();
            } else {
              Provider.of<Translation>(context, listen: false)
                  .toggleTranslation();
              _controller.reverse();
            }
          },
        );
      }),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> content;
  const CustomWidget({
    this.title,
    this.content,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(bottom: 12, right: 12, top: 12, left: 30),
            margin: const EdgeInsets.only(
              bottom: 7,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              color: Color(0xFF37323E),
            ),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 6, bottom: 28, left: 12, right: 12),
            child: Consumer<Translation>(builder: (_, tanslation, ch) {
              return Text(
                Provider.of<Translation>(context, listen: true).getIsEnglish()
                    ? content['english']
                    : content['hindi'],
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500),
              );
            }),
          ),
        ],
      ),
    );
  }
}
