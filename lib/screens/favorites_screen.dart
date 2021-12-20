import 'package:flutter/material.dart';
import '../widgets/favorite_shlok_item.dart';

class FavoritesScreen extends StatelessWidget {
  static const String routeName = "/favorites-screen";

  @override
  void initState() {}
  List<Map<String, dynamic>> shlok = [
    {
      "Shlok": """
क्लैब्यं मा स्म गमः पार्थ नैतत्त्वय्युपपद्यते।
क्षुद्रं हृदयदौर्बल्यं त्यक्त्वोत्तिष्ठ परन्तप।।
                      """,
      "Audio": "",
      "Number": "अ.१, श्लोक.१",
      "Chapter": "Chapter02",
      "hlok": "Shlok03",
    },
    {
      "Shlok": """
ये त्वक्षरमनिर्देश्यमव्यक्तं पर्युपासते।
सर्वत्रगमचिन्त्यं च कूटस्थमचलं ध्रुवम्‌ ॥
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.14",
      "Chapter": "Chapter02",
      "hlok": "Shlok14",
    },
    {
      "Shlok": """
सन्नियम्येन्द्रियग्रामं सर्वत्र समबुद्धयः ।
ते प्राप्नुवन्ति मामेव सर्वभूतहिते रताः ॥
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.20",
      "Chapter": "Chapter02",
      "hlok": "Shlok20",
    },
    {
      "Shlok": """
क्लेशोऽधिकतरस्तेषामव्यक्तासक्तचेतसाम्‌ ।
अव्यक्ता हि गतिर्दुःखं देहवद्भिरवाप्यते ॥
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.31",
      "Chapter": "Chapter02",
      "hlok": "Shlok31",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange.shade200,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.orange.shade600,
              expandedHeight: 240,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                title: const Text(
                  "Favorites",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                background: Image.asset(
                  "assets/images/shrikrushnaArjun.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => FavoriteShlokItem(shlok[index], index),
                childCount: shlok.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
