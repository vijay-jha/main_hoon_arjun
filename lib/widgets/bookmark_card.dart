import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../adhyay_detail.dart';
import '../screens/adhyay_overview_screen.dart';

class BookmarkCard extends StatelessWidget {
  BookmarkCard(this.shlok);

  final Map<String, dynamic> shlok;
  var shlokList = <String>[];
  var chapterdata = <Map<String, dynamic>>[];

  void getChapterData(chapter) async {
    var adhyay =
        await FirebaseFirestore.instance.collection('Geeta').doc(chapter).get();

    var adhyayData = adhyay.data();
    var data = adhyayData.keys.toList();
    data.sort((a, b) => a.toString().compareTo(b.toString()));
    shlokList = data;
    for (var i = 0; i < shlokList.length; i++) {
      chapterdata.insert(
          i, Map<String, dynamic>.from(adhyay.get(shlokList[i])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    getChapterData(shlok['Chapter']);
    return Card(
      margin: EdgeInsets.only(
        top: _deviceSize.height * 0.02, // 7.5,
        bottom: _deviceSize.height * 0.008, // 7.5
        left: _deviceSize.width * 0.025, // 10
        right: _deviceSize.width * 0.025, // 10
      ),
      color: Colors.orange.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
      child: Container(
        // height: _deviceSize.height * 0.300, //240
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: _deviceSize.height * 0.012, // 10
              ),
              padding: EdgeInsets.only(
                left: _deviceSize.width * 0.063, // 25
                right: _deviceSize.width * 0.05, // 18
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      shlok['Number'],
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                getChapterData(shlok['Chapter']);
                int index = geetaChapters.indexWhere(
                    (element) => element['number'] == shlok['Chapter']);

                int initialno = shlokList.indexWhere(
                    (element) => element == shlok['ShlokNo'].toString());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdhyayOverviewScreen(
                      shlokList: shlokList,
                      chapterData: chapterdata,
                      title: geetaChapters[index]['number'],
                      adhyayName: geetaChapters[index]['name'],
                      initialPage: initialno,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: _deviceSize.width * 0.035, //14
                  top: _deviceSize.height * 0.005, //5,
                  right: _deviceSize.width * 0.035, //14
                  bottom: _deviceSize.height * 0.02, //5,
                ),
                child: ShlokCard(
                  shlok: shlok['Shlok'],
                  deviceSize: _deviceSize,
                ),
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShlokCard extends StatelessWidget {
  ShlokCard({@required this.shlok, this.deviceSize});
  final String shlok;
  final deviceSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.065, //19,
          vertical: deviceSize.height * 0.01,
        ),
        height: deviceSize.height * 0.180, // 165
        alignment: Alignment.center,
        child: Text(
          shlok.trim(),
          style: TextStyle(
            fontSize: deviceSize.height * 0.027,
            color: Colors.orange.shade800,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
