import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:main_hoon_arjun/screens/adhyay_overview_screen.dart';

class Adhyay extends StatelessWidget {
  final String title;
  final String name;
  Adhyay(this.title, this.name);

  var chapterdata = <Map<String, dynamic>>[];
  var shlokList = <String>[];

  Future<int> getChapterData(chapter) async {
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

    return Future.value(1);
  }

  @override
  Widget build(BuildContext context) {
    var _deivceSize = MediaQuery.of(context).size;
    print(title);
    getChapterData(title);

    return FutureBuilder(
        future: getChapterData(title),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCircle(
              color: Colors.orange,
            );
          }
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdhyayOverviewScreen(
                    shlokList: shlokList,
                    chapterData: chapterdata,
                    title: title,
                    adhyayName: name,
                    initialPage: 0,
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: _deivceSize.height * 0.011,
                    horizontal: _deivceSize.width * 0.027),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 7.0,
                    ),
                  ],
                ),
                // width: 170,
                // // height: 200,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: _deivceSize.width * 0.0075,
                        right: _deivceSize.width * 0.0075,
                        top: _deivceSize.height * 0.0035,
                        bottom: _deivceSize.height * 0.0058,
                      ),
                      // padding: EdgeInsets.all(2),
                      height: _deivceSize.height * 0.223,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: Image.asset(
                          "assets/images/Geeta.jfif",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: _deivceSize.width * 0.018,
                          top: _deivceSize.height * 0.005),
                      width: double.infinity,
                      child: Text(
                        name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontFamily: 'NotoSansMono',
                          fontSize: _deivceSize.height * 0.022,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: _deivceSize.width * 0.018),
                      width: double.infinity,
                      child: Text(
                        title.substring(0, 7) + " " + title.substring(7),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontFamily: 'NotoSansMono',
                          fontSize: _deivceSize.height * 0.015,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SpinKitCircle(
            color: Colors.orange,
          );
        });
  }
}