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
  bool isLastPage = false;

  VersePage({
    @required this.verseNumber,
    this.currentShlok,
    this.pageController,
    this.shlokTitle,
    this.shlokText,
    this.translation,
    this.meaning,
    this.isLastPage,
  });

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  var doc;
  bool isBookmark;

  @override
  Future<void> dispose() async {
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
    final _deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Shlok number
          Container(
            margin: EdgeInsets.only(
              top: _deviceSize.height * 0.01,
              bottom: _deviceSize.height * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF37323E),
            ),
            padding: const EdgeInsets.all(10),
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
                      return Icon(
                        Icons.bookmark_border,
                        color: Colors.orange,
                      );
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
                    return Icon(
                      Icons.bookmark_border,
                      color: Colors.orange,
                    );
                  }),
              TranslationBtn(),
            ],
          ),

          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: _deviceSize.height * 0.02,
                horizontal: _deviceSize.width * 0.05,
              ),
              margin: EdgeInsets.symmetric(
                vertical: _deviceSize.height * 0.02,
                horizontal: _deviceSize.width * 0.1,
              ),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          CustomWidget(title: "Meaning", content: widget.translation),
          CustomWidget(title: "Explanation", content: widget.meaning),

          // Navigation arrows
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
                    margin: EdgeInsets.only(
                      left: _deviceSize.width * 0.1,
                      top: _deviceSize.height * 0.01,
                      bottom: _deviceSize.height * 0.02,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        //arrow
                        Icon(Icons.keyboard_arrow_left_sharp,
                            color: Colors.orange),
                        Text(
                          "Prev",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.isLastPage == false)
                GestureDetector(
                  onTap: () {
                    widget.pageController.animateToPage(widget.verseNumber,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.bounceInOut);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                        right: _deviceSize.width * 0.1,
                        top: _deviceSize.height * 0.01,
                        bottom: _deviceSize.height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          //arrow
                          Text(
                            "Next",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.orange,
                          ),
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
              ? Image.asset(
                  'assets/images/translationEnglish.png',
                )
              : Image.asset('assets/images/translationHindi.png'),
          onPressed: () {
            if (!isEnglish) {
              _controller.reset();
              _controller.forward();
              Provider.of<Translation>(context, listen: false)
                  .toggleTranslation();
            } else {
              _controller.reset();
              _controller.forward();
              Provider.of<Translation>(context, listen: false)
                  .toggleTranslation();
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
    final _deviceSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: _deviceSize.height * 0.015,
              horizontal: _deviceSize.width * 0.05,
            ),
            margin: EdgeInsets.only(
              top: _deviceSize.height * 0.02,
              left: _deviceSize.width * 0.05,
              right: _deviceSize.width * 0.05,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              color: Color(0xFF37323E),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            decoration: BoxDecoration(
               borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _deviceSize.width * 0.03,
              vertical: _deviceSize.height * 0.001,
            ),
            margin: EdgeInsets.only(
              bottom: _deviceSize.height * 0.02,
              left: _deviceSize.width * 0.05,
              right: _deviceSize.width * 0.05,
            ),
            child: Consumer<Translation>(builder: (_, tanslation, ch) {
              return Text(
                Provider.of<Translation>(context, listen: true).getIsEnglish()
                    ? content['english']
                    : content['hindi'],
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
