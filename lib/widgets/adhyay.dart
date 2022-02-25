import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/screens/adhyay_overview_screen.dart';

class Adhyay extends StatelessWidget {
  final String title;
  final String name;
  Adhyay(this.title, this.name);
  
  var chapterdata = <Map<String, dynamic>>[];
  var shlokList = <String>[];

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
    print(title);
    getChapterData(title);
    
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
        padding:
            const EdgeInsets.only(left: 11, top: 10, bottom: 10, right: 11),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          width: 170,
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 2, left: 2, right: 2, bottom: 5),
                // padding: EdgeInsets.all(2),
                height: 190,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Image.asset(
                    "assets/images/Geeta.jfif",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 4, top :5),
                width: double.infinity,
                child: Text(
                  name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontFamily: 'NotoSansMono',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 3,
                ),
                width: double.infinity,
                child: Text(
                  ' $title ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontFamily: 'NotoSansMono',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
