
import 'package:flutter/material.dart';

import '../widgets/profile_picture.dart';
import '../widgets/adhyay.dart';

class GeetaReadScreen extends StatelessWidget {
  static const routeName = '/geeta-read-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Geeta"),
        actions: [ProfilePicture()],
      ),
      body: GridView(
        clipBehavior: Clip.none,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 3,
          maxCrossAxisExtent: 197,
          childAspectRatio: 1.27 / 1.9,
          crossAxisSpacing: 0.1,
        ),
        children: [
          Adhyay('ADHYAY-1', 'अर्जुनविषादयोग'),
          Adhyay('ADHYAY-2', 'सांख्ययोग'),
          Adhyay('ADHYAY-3', 'कर्मयोग'),
          Adhyay('ADHYAY-4', 'ज्ञानकर्मसंन्यासयोग'),
          Adhyay('ADHYAY-5', 'कर्मसंन्यास'),
          Adhyay('ADHYAY-6', 'आत्मसंयम'),
          Adhyay('ADHYAY-7', 'ज्ञानविज्ञान '),
          Adhyay('ADHYAY-8', 'ब्रह्मयोग'),
          Adhyay('ADHYAY-9', 'राजगुह्ययोग'),
          Adhyay('ADHYAY-10', 'विभूति '),
          Adhyay('ADHYAY-11', 'विश्वरूप दर्शन'),
          Adhyay('ADHYAY-12', 'भक्ति'),
          Adhyay('ADHYAY-13', 'विभाग'),
          Adhyay('ADHYAY-14', 'गुण-त्रय विभाग'),
          Adhyay('ADHYAY-15', 'पुरुषोतम'),
          Adhyay('ADHYAY-16', 'दैवासुरसंपद्विभाग'),
          Adhyay('ADHYAY-17', 'श्र्द्धात्रयविभाग'),
          Adhyay('ADHYAY-18', 'मोक्षसंन्यासयोग'),
        ],
      ),
      // body: GridView(),
    );
  }
}
