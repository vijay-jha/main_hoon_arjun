import 'package:flutter/material.dart';
import '../widgets/favorite_shlok_item.dart';

class FavoritesScreen extends StatelessWidget {
  static const String routeName = "/favorites-screen";

  List<Map<String, dynamic>> shlok = [
    {
      "Shlok": """
कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।
मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥
                      """,
      "Audio": "",
      "Number": "अ.१, श्लोक.१"
    },
    {
      "Shlok": """
ये त्वक्षरमनिर्देश्यमव्यक्तं पर्युपासते।
सर्वत्रगमचिन्त्यं च कूटस्थमचलं ध्रुवम्‌ ॥
                      """,
      "Audio": "",
      "Number": "अ.१२, श्लोक.३"
    },
    {
      "Shlok": """
सन्नियम्येन्द्रियग्रामं सर्वत्र समबुद्धयः ।
ते प्राप्नुवन्ति मामेव सर्वभूतहिते रताः ॥
                      """,
      "Audio": "",
      "Number": "Ch.12, Sh.4"
    },
    {
      "Shlok": """
क्लेशोऽधिकतरस्तेषामव्यक्तासक्तचेतसाम्‌ ।
अव्यक्ता हि गतिर्दुःखं देहवद्भिरवाप्यते ॥
                      """,
      "Audio": "",
      "Number": "अ.१२, श्लोक.५"
    },
    {
      "Shlok": """
ये तु सर्वाणि कर्माणि मयि सन्नयस्य मत्पराः ।
अनन्येनैव योगेन मां ध्यायन्त उपासते ॥
                      """,
      "Audio": "",
      "Number": "अ.१२, श्लोक ६"
    },
    {
      "Shlok": """
तेषामहं समुद्धर्ता मृत्युसंसारसागरात्‌ ।
भवामि नचिरात्पार्थ मय्यावेशितचेतसाम्‌ ॥
                      """,
      "Audio": "",
      "Number": "अ.१२, श्लोक ७"
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
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                title: const Text(
                  "Favorites",
                  style: TextStyle(
                      color: Colors.white,),
                ),
                background: Image.asset(
                  "assets/images/shrikrushnaArjun.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // FavoritesShlok(),
            SliverList(
              delegate: SliverChildListDelegate([
                ...shlok.map((shlok) => FavoriteShlokItem(shlok)).toList(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
