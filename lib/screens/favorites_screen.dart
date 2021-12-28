import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/favorite_shlok.dart';
import '../widgets/speaker_icon_button.dart';
import '../providers/playing_shlok.dart';
import '../widgets/profile_picture.dart';

class FavoritesScreen extends StatelessWidget {
  static const String routeName = "/favorites-screen";

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
मात्रास्पर्शास्तु कौन्तेय शीतोष्णसुखदुःखदाः।
आगमापायिनोऽनित्यास्तांस्तितिक्षस्व भारत।।
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.14",
      "Chapter": "Chapter02",
      "hlok": "Shlok14",
    },
    {
      "Shlok": """
न जायते म्रियते वा कदाचि
नायं भूत्वा भविता वा न भूय: |
अजो नित्य: शाश्वतोऽयं पुराणो
न हन्यते हन्यमाने शरीरे ||
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.20",
      "Chapter": "Chapter02",
      "hlok": "Shlok20",
    },
    {
      "Shlok": """
यदा ते मोहकलिलं बुद्धिर्व्यतितरिष्यति |
तदा गन्तासि निर्वेदं श्रोतव्यस्य श्रुतस्य च ||
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.52",
      "Chapter": "Chapter02",
      "hlok": "Shlok52",
    },
    {
      "Shlok": """
स्वधर्ममपि चावेक्ष्य न विकम्पितुमर्हसि |
धर्म्याद्धि युद्धाच्छ्रेयोऽन्यत्क्षत्रियस्य न विद्यते ||
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.31",
      "Chapter": "Chapter02",
      "hlok": "Shlok31",
    },
    {
      "Shlok": """
हतो वा प्राप्स्यसि स्वर्गं जित्वा वा भोक्ष्यसे महीम् |
तस्मादुत्तिष्ठ कौन्तेय युद्धाय कृतनिश्चय: ||
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.37",
      "Chapter": "Chapter02",
      "hlok": "Shlok37",
    },
    {
      "Shlok": """
कर्मण्येवाधिकारस्ते मा फलेषु कदाचन |
मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ||
                      """,
      "Audio": "",
      "Number": "अ.02, श्लोक.47",
      "Chapter": "Chapter02",
      "hlok": "Shlok47",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PlayingShlok(),
        )
      ],
      child: Scaffold(
        body: Container(
          color: Colors.orange.shade300,
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
              FavoritesItemList(shlok: shlok),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesItemList extends StatefulWidget {
  const FavoritesItemList({
    Key key,
    @required this.shlok,
  }) : super(key: key);

  final List<Map<String, dynamic>> shlok;

  @override
  State<FavoritesItemList> createState() => _FavoritesItemListState();
}

class _FavoritesItemListState extends State<FavoritesItemList> {
  @override
  void dispose() {
    super.dispose();
    SpeakerIcnBtn.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FavoriteShlokItem(widget.shlok[index], index),
        childCount: widget.shlok.length,
      ),
    );
  }
}
