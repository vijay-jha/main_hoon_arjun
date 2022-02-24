import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/screens/bookmark_screen.dart';

import '../widgets/profile_picture.dart';
import '../widgets/adhyay.dart';

class GeetaReadScreen extends StatefulWidget {
  static const routeName = '/geeta-read-screen';

  @override
  State<GeetaReadScreen> createState() => _GeetaReadScreenState();
}

class _GeetaReadScreenState extends State<GeetaReadScreen> {
  var finalData = <Map<String, dynamic>>[];
  var doc;

  @override
  void initState() {
    super.initState();
    () async {
      var _user = FirebaseAuth.instance.currentUser;
      doc = await FirebaseFirestore.instance
          .collection('Bookmark')
          .doc(_user.uid)
          .get();
    }();
    if (doc != null) {
      if (!doc.exists) {
        FirebaseFirestore.instance
            .collection('Bookmark')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({'bookmarked_shloks': []});
      }
    }
  }

  List<Map<String, dynamic>> geetaChapters = [
    {'number': 'Chapter01', 'name': 'अर्जुनविषादयोग'},
    {'number': 'Chapter02', 'name': 'सांख्ययोग'},
    {'number': 'Chapter03', 'name': 'कर्मयोग'},
    {'number': 'Chapter04', 'name': 'ज्ञानकर्मसंन्यासयोग'},
    {'number': 'Chapter05', 'name': 'कर्मसंन्यासयोग'},
    {'number': 'Chapter06', 'name': 'आत्मसंयमयोग'},
    {'number': 'Chapter07', 'name': 'ज्ञानविज्ञानयोग'},
    {'number': 'Chapter08', 'name': 'ब्रह्मयोग'},
    {'number': 'Chapter09', 'name': 'राजगुह्ययोग'},
    {'number': 'Chapter10', 'name': 'विभूतियोग'},
    {'number': 'Chapter11', 'name': 'विश्वरूपदर्शनयोग'},
    {'number': 'Chapter12', 'name': 'भक्तियोग'},
    {'number': 'Chapter13', 'name': 'क्षेत्रक्षेत्रज्ञविभागयोग'},
    {'number': 'Chapter14', 'name': 'गुण-त्रयविभागयोग'},
    {'number': 'Chapter15', 'name': 'पुरुषोतमयोग'},
    {'number': 'Chapter16', 'name': 'दैवासुरसंपद्विभागयोग'},
    {'number': 'Chapter17', 'name': 'श्र्द्धात्रयविभागयोग'},
    {'number': 'Chapter18', 'name': 'मोक्षसंन्यासयोग'},
  ];

  void getChapterData(chapter) async {
    var adhyay =
        await FirebaseFirestore.instance.collection('Geeta').doc(chapter).get();
    var adhyayData = adhyay.data();
    var data = adhyayData.keys.toList();
    data.sort((a, b) => a.toString().compareTo(b.toString()));

    for (var i = 0; i < data.length; i++) {
      finalData.insert(i, Map<String, dynamic>.from(adhyay.get(data[i])));
    }

    for (var i = 0; i < finalData.length; i++) {
      print(finalData[i]['shlok']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getChapterData('Chapter02');
    return Scaffold(
      floatingActionButton: ElevatedButton(
        child: const Icon(Icons.bookmark),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<CircleBorder>(
              const CircleBorder(),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BookmarkScreen()));
        },
      ),
      appBar: AppBar(
        title: const Text("Shrimad Bhagavad Geeta"),
        actions: [ProfilePicture()],
      ),
      backgroundColor: Colors.orange.shade50,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Bookmark')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.orange[700],
            ));
          }
          if (snapshot.hasData) {
            return GridView.builder(
              clipBehavior: Clip.none,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 3,
                maxCrossAxisExtent: 197,
                childAspectRatio: (MediaQuery.of(context).size.width / 0.6) /
                    (MediaQuery.of(context).size.height / 0.9),
                crossAxisSpacing: 0.1,
              ),
              itemCount: geetaChapters.length,
              itemBuilder: (_, index) => Adhyay(geetaChapters[index]['number'],
                  geetaChapters[index]['name'], snapshot.data),
            );
          }
          return const Center();
        },
      ),
      // body: GridView(),
    );
  }
}
