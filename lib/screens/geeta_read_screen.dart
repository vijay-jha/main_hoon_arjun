import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_hoon_arjun/screens/bookmark_screen.dart';

import '../widgets/profile_picture.dart';
import '../widgets/adhyay.dart';

class GeetaReadScreen extends StatelessWidget {
  static const routeName = '/geeta-read-screen';

  GeetaReadScreen({Key key}) : super(key: key);

  // var mainData =  <Map<String, dynamic>>[];
  var finalData =  <Map<String, dynamic>>[];

  void getChapterData(chapter) async {
    var adhyay = await FirebaseFirestore.instance
        .collection('Geeta')
        .doc(chapter)
        .get();
    var adhyayData = adhyay.data();
    var data = adhyayData.keys.toList();
    data.sort((a, b) => a.toString().compareTo(b.toString()));

    for (var i = 0; i < data.length; i++) {
      finalData.insert(i,Map<String, dynamic>.from(adhyay.get(data[i])));
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
      body: GridView(
        clipBehavior: Clip.none,
        // crossAxisCount: 2,
        // mainAxisSpacing: 100,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 3,
          maxCrossAxisExtent: 197,
          childAspectRatio: (MediaQuery.of(context).size.width / 0.6) /
              (MediaQuery.of(context).size.height / 0.9),
          crossAxisSpacing: 0.1,
        ),
        children: [
          Adhyay(
            'Chapter01',
            'अर्जुनविषादयोग',
            47,
          ),
          Adhyay(
            'Chapter02',
            'सांख्ययोग',
            47,
          ),
          Adhyay(
            'Chapter03',
            'कर्मयोग',
            47,
          ),
          Adhyay('Chapter04', 'ज्ञानकर्मसंन्यासयोग', 47),
          Adhyay(
            'Chapter05',
            'कर्मसंन्यास',
            47,
          ),
          Adhyay(
            'Chapter06',
            'आत्मसंयम',
            47,
          ),
          Adhyay(
            'Chapter07',
            'ज्ञानविज्ञान ',
            47,
          ),
          Adhyay(
            'Chapter08',
            'ब्रह्मयोग',
            47,
          ),
          Adhyay(
            'Chapter09',
            'राजगुह्ययोग',
            47,
          ),
          Adhyay(
            'Chapter10',
            'विभूति ',
            47,
          ),
          Adhyay(
            'Chapter11',
            'विश्वरूप दर्शन',
            47,
          ),
          Adhyay('Chapter12', 'भक्ति', 47),
          Adhyay(
            'Chapter13',
            'विभाग',
            47,
          ),
          Adhyay(
            'Chapter14',
            'गुण-त्रय विभाग',
            47,
          ),
          Adhyay(
            'Chapter15',
            'पुरुषोतम',
            47,
          ),
          Adhyay(
            'Chapter16',
            'दैवासुरसंपद्विभाग',
            47,
          ),
          Adhyay(
            'Chapter17',
            'श्र्द्धात्रयविभाग',
            47,
          ),
          Adhyay(
            'Chapter18',
            'मोक्षसंन्यासयोग',
            47,
          ),
        ],
      ),
      // body: GridView(),
    );
  }
}
