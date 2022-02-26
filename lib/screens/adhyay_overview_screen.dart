import 'dart:async';

import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/providers/translation.dart';
import 'package:provider/provider.dart';

import 'package:main_hoon_arjun/widgets/shlok_selection.dart';
import 'package:main_hoon_arjun/widgets/verse_page.dart';

class AdhyayOverviewScreen extends StatefulWidget {
  static const routename = "/AdhyayOverviewScreen";

  final String title;
  final String adhyayName;
  final List<Map<String, dynamic>> chapterData;
  final List<String> shlokList;
  final int initialPage;

  bool isBookmarked;
  String bookmarkedShlok;

  AdhyayOverviewScreen({
    this.title,
    this.adhyayName,
    this.chapterData,
    this.shlokList,
    this.initialPage,
  });

  @override
  State<AdhyayOverviewScreen> createState() => _AdhyayOverviewScreenState();
}

class _AdhyayOverviewScreenState extends State<AdhyayOverviewScreen> {
  PageController controller;
  int pagechanged;
  String currentShlok;
  bool isBookmark;

  var doc;

  @override
  void initState() {
    super.initState();
    pagechanged = widget.initialPage + 1;
    controller = PageController(initialPage: widget.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Translation(),
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Scaffold(
          backgroundColor: Colors.orange.shade50,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65.0),
              child: BuildAppBar(
                chapterData: widget.chapterData,
                shlokList: widget.shlokList,
                controller: controller,
                adhyayName: widget.adhyayName,
                adhyayNumber: widget.title,
              )),
          body: Stack(
            children: [
              PageView.builder(
                onPageChanged: (index) {
                  pagechanged = index + 1;
                },
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return index == widget.shlokList.length-1 ? VersePage(
                    isLastPage: true,
                    currentShlok:
                        "Chapter${widget.chapterData[index]['chapter']}_${widget.shlokList[index]}",
                    verseNumber: index + 1,
                    shlokTitle: widget.chapterData[index]['shlok'],
                    pageController: controller,
                    shlokText: widget.chapterData[index]['text'],
                    meaning: widget.chapterData[index]['meaning'],
                    translation: widget.chapterData[index]['translation'],
                  ) : VersePage(
                    isLastPage: false,
                    currentShlok:
                        "Chapter${widget.chapterData[index]['chapter']}_${widget.shlokList[index]}",
                    verseNumber: index + 1,
                    shlokTitle: widget.chapterData[index]['shlok'],
                    pageController: controller,
                    shlokText: widget.chapterData[index]['text'],
                    meaning: widget.chapterData[index]['meaning'],
                    translation: widget.chapterData[index]['translation'],
                  );
                },
                itemCount: widget.shlokList.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildAppBar extends StatelessWidget {
  final PageController controller;

  BuildAppBar({
    @required this.controller,
    @required this.adhyayName,
    @required this.adhyayNumber,
    @required this.chapterData,
    @required this.shlokList,
  });

  final String adhyayName;
  final String adhyayNumber;
  final List<Map<String, dynamic>> chapterData;
  final List<String> shlokList;

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.orange, //change your color here
      ),
      elevation: 0,
      backgroundColor:  Colors.orange.shade50,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                left: _deviceSize.width * 0.05,
                top: _deviceSize.height * 0.01,
                bottom: 0,
              ),
              child: Text(
                adhyayName,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold),
              )),
          Padding(
            
              padding: EdgeInsets.only(
                top: 0,
                left: _deviceSize.width * 0.05,
              ),
              child: Text(
                adhyayNumber,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
      actions: [
        Padding(
          padding:  EdgeInsets.only(right: _deviceSize.width * 0.03,),
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShlokSelection(
                        chapterData: chapterData,
                        shlokList: shlokList,
                        pageController: controller,
                      );
                    });
              },
              icon: Image.asset(
                "assets/images/gridViewIcon.png",
                height: 26,
              )),
        )
      ],
    );
  }
}
